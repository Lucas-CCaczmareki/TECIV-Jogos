extends Node
class_name PuzzleController

# TDD 11 (Puzzles): elementos emitem signals próprios (toggled / activated),
# o controller agrupa com uma regra e emite `solved`, que abre as Doors.
# É o canal LOCAL do puzzle: não passa pelo Events (chamar pra baixo, avisar pra cima).
#
# Contrato esperado dos elementos (Lever, PressurePlate, Totem...):
#   - signal toggled(is_on: bool)  OU  signal activated()
#   - is_active() -> bool            (opcional, estado inicial)
#   - reset_puzzle() -> void         (opcional, chamado quando o desafio falha)

enum Rule {
	ALL,         # todos ativos ao mesmo tempo (placa + alavanca, várias alavancas)
	SEQUENCE,    # ativar na ordem do array `elements`; errar reinicia o desafio
	TIME_WINDOW, # todos ativos dentro de `window_time` segundos; senão reinicia
}

signal solved
signal unsolved # só acontece com latch = false (ex.: placa que segura a porta)
signal failed   # SEQUENCE errada ou janela de tempo estourada

@export var rule: Rule = Rule.ALL
@export var elements: Array[Node] = []
@export var doors: Array[Door] = []
@export var open_doors_on_solve := true
@export var reset_on_player_death := false
@export_range(0.1, 30.0, 0.1) var window_time: float = 3.0 # só TIME_WINDOW
## true: depois de resolvido fica resolvido. false (só Rule.ALL): se um elemento
## desativar, as portas fecham de novo (ex.: lobo saiu da placa).
@export var latch: bool = true

var is_solved := false

var _active: Dictionary = {} # Node -> bool
var _progress := 0           # SEQUENCE: índice do próximo elemento esperado
var _resetting := false      # ignora signals gerados pelo próprio reset
var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_on_window_expired)
	add_child(_timer)

	if elements.is_empty():
		push_warning("PuzzleController '%s' sem elementos." % name)

	for el in elements:
		if not is_instance_valid(el):
			continue
		_active[el] = el.has_method("is_active") and el.is_active()
		if el.has_signal("toggled"):
			el.connect("toggled", _on_toggled.bind(el))
		elif el.has_signal("activated"):
			el.connect("activated", _on_activated.bind(el))
		else:
			push_warning("'%s' não tem signal toggled/activated." % el.name)

	if reset_on_player_death:
		var player := get_tree().get_first_node_in_group("player")
		if player == null:
			push_warning("PuzzleController '%s' não encontrou o jogador para conectar a morte." % name)
		else:
			var health := player.get_node_or_null("HealthComponent") as HealthComponent
			if health == null:
				push_warning("PuzzleController '%s' não encontrou HealthComponent no jogador." % name)
			else:
				health.died.connect(_on_player_died)

	# as Doors podem não estar prontas ainda (ordem de _ready), então avalia depois
	if rule == Rule.ALL:
		_check_all.call_deferred()

# ---------- API pública ----------

## Volta o desafio ao início (fecha as portas e reseta os elementos).
func reset_puzzle() -> void:
	_timer.stop()
	if is_solved:
		is_solved = false
		_set_doors(false)
	_reset_elements()

func _on_player_died() -> void:
	reset_puzzle()

func _on_player_fell(_body: Node2D) -> void:
	reset_puzzle()

# ---------- reação aos elementos ----------

func _on_toggled(value: bool, el: Node) -> void:
	_set_element_state(el, value)

func _on_activated(el: Node) -> void:
	_set_element_state(el, true)

func _set_element_state(el: Node, value: bool) -> void:
	if _resetting:
		return
	var was: bool = _active.get(el, false)
	_active[el] = value

	if is_solved:
		if not latch and rule == Rule.ALL and not value:
			_unsolve()
		return

	match rule:
		Rule.ALL:
			_check_all()
		Rule.SEQUENCE:
			if value and not was:
				_on_sequence_step(el)
		Rule.TIME_WINDOW:
			if value and not was:
				_on_window_step()

func _check_all() -> void:
	if is_solved or elements.is_empty():
		return
	if _all_active():
		_solve()

func _on_sequence_step(el: Node) -> void:
	if el == elements[_progress]:
		_progress += 1
		if _progress >= elements.size():
			_solve()
	else:
		_fail()

func _on_window_step() -> void:
	if _timer.is_stopped():
		_timer.start(window_time) # a janela começa na primeira ativação
	if _all_active():
		_solve()

func _on_window_expired() -> void:
	if not is_solved:
		_fail()

# ---------- resultado ----------

func _solve() -> void:
	is_solved = true
	_timer.stop()
	_set_doors(true)
	solved.emit()

func _unsolve() -> void:
	is_solved = false
	_set_doors(false)
	unsolved.emit()

# Falhar reinicia só o desafio, sem afetar o resto da chunk (GDD 07)
func _fail() -> void:
	_timer.stop()
	_reset_elements()
	failed.emit()

func _reset_elements() -> void:
	_resetting = true
	_progress = 0
	for el in elements:
		if not is_instance_valid(el):
			continue
		if el.has_method("reset_puzzle"):
			el.reset_puzzle()
		_active[el] = el.has_method("is_active") and el.is_active()
	_resetting = false

func _all_active() -> bool:
	for el in elements:
		if not is_instance_valid(el) or not _active.get(el, false):
			return false
	return true

func _set_doors(open: bool) -> void:
	for door in doors:
		if not is_instance_valid(door):
			continue
		if open:
			if open_doors_on_solve:
				door.open()
			else:
				door.unlock()
		else:
			if open_doors_on_solve:
				door.close()
			else:
				door.lock()
