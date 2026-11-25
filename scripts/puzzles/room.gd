extends Area2D
class_name Room

# TDD 11 (Ciclo de uma Room): o jogador entra -> tranca as portas de entrada ->
# ondas de inimigos (definidas por RoomSpawn filhos) -> sala limpa -> abre as portas.
# Sala limpa não reativa.
# Cada onda só começa quando todos os inimigos da anterior morreram.

signal started
signal wave_started(wave_index: int)
signal cleared

enum State { IDLE, ACTIVE, CLEARED }

@export var room_id: StringName
## Portas abertas por padrão que fecham quando a sala começa (Door.start_open = true)
@export var entry_doors: Array[Door] = []
## Portas fechadas que abrem quando a sala é limpa
@export var exit_doors: Array[Door] = []

var state: State = State.IDLE

var _spawns: Array[RoomSpawn] = []
var _wave := -1
var _wave_count := 0
var _alive := 0   # inimigos vivos da onda
var _pending := 0 # inimigos da onda que ainda não nasceram (têm delay)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	for node in find_children("*", "RoomSpawn", true, false):
		var spawn := node as RoomSpawn
		_spawns.append(spawn)
		_wave_count = maxi(_wave_count, spawn.wave + 1)

	if _spawns.is_empty():
		push_warning("Room '%s' sem RoomSpawn." % name)

# Pro Game (G2): ao recarregar a chunk, salas já limpas voltam abertas e sem inimigos
func restore_as_cleared() -> void:
	state = State.CLEARED
	set_deferred("monitoring", false)
	_set_doors(entry_doors, true)
	_set_doors(exit_doors, true)

func _on_body_entered(body: Node2D) -> void:
	if state != State.IDLE or not body.is_in_group("player"):
		return
	state = State.ACTIVE
	# o signal chega durante o flush de física; mexer em corpos aqui dá erro
	_start.call_deferred()

func _start() -> void:
	set_deferred("monitoring", false)
	_set_doors(entry_doors, false)
	started.emit()
	Events.room_started.emit(room_id)
	_next_wave()

func _next_wave() -> void:
	if state != State.ACTIVE:
		return
	_wave += 1
	if _wave >= _wave_count:
		_clear()
		return

	var entries: Array[RoomSpawn] = []
	for spawn in _spawns:
		if spawn.wave == _wave:
			entries.append(spawn)
	if entries.is_empty():
		_next_wave()
		return

	wave_started.emit(_wave)
	_pending = entries.size()
	for spawn in entries:
		_spawn_enemy(spawn) # corrotinas rodam em paralelo (cada uma com seu delay)

func _spawn_enemy(spawn: RoomSpawn) -> void:
	if spawn.delay > 0.0:
		await get_tree().create_timer(spawn.delay).timeout
	if state != State.ACTIVE or not is_inside_tree():
		return

	_pending -= 1
	if spawn.scene == null:
		push_warning("RoomSpawn '%s' sem cena." % spawn.name)
		_check_wave_done()
		return

	var enemy: Node2D = spawn.scene.instantiate()
	get_parent().add_child(enemy) # filho da chunk, não da Room (a Room é só uma área)
	enemy.global_position = spawn.global_position
	_alive += 1
	enemy.tree_exited.connect(_on_enemy_gone, CONNECT_ONE_SHOT)

func _on_enemy_gone() -> void:
	if state != State.ACTIVE or not is_inside_tree():
		return
	_alive -= 1
	_check_wave_done()

func _check_wave_done() -> void:
	if _alive <= 0 and _pending <= 0:
		_next_wave.call_deferred()

func _clear() -> void:
	state = State.CLEARED
	_set_doors(entry_doors, true)
	_set_doors(exit_doors, true)
	cleared.emit()
	Events.room_cleared.emit(room_id)

func _set_doors(doors: Array[Door], open: bool) -> void:
	for door in doors:
		if not is_instance_valid(door):
			continue
		if open:
			door.open()
		else:
			door.close()
