extends Character

# ==============================================================================
# AJUSTES (editáveis no Inspector)
# ==============================================================================
@export var dodge_speed_mult: float = 2.8
@export var sprint_mult: float = 1.5
@export var dodge_duration: float = 0.60
@export var dodge_cooldown: float = 0.20 # o tempo total entre esquivas é dodge_duration + cooldown (o cooldown só conta depois que a rolagem termina)

@export var dodge_cost: float = 60.0
@export var sprint_cost: float = 35.0

# se true, a rolagem é imune a empurrão (zera o knockback ao começar e ignora novos durante a rolagem)
@export var dodge_ignores_knockback: bool = true

# ==============================================================================
# ESTADO
# ==============================================================================
# estados. ("Travado" continua sendo a flag can_move)
enum State { MOVE, SPRINT, DODGE, DEAD }
var state: State = State.MOVE # variavel

# somente leitura: derivados do estado, então não existe a chance de ficarem dessincronizados
var is_dodging: bool:
	get:
		return state == State.DODGE
var is_dead: bool:
	get:
		return state == State.DEAD

var dodge_timer: float = 0
var dodgeCooldown_timer: float = 0

var input_vector: Vector2 = Vector2.ZERO # Vector2 é parecido com std::pair<float, float>

var dodge_direction: Vector2 = Vector2.ZERO
var can_dodge: bool = true
var is_reloading: bool = false
var can_move: bool = true
var airborne: bool = false

# ==============================================================================
# NÓS
# ==============================================================================
@onready var sprite: DirectionalSprite = $Sprite
@onready var weapon_manager: WeaponManager = $WeaponManager
@onready var reload_bar: TextureProgressBar = $ReloadBar
@onready var weapon_pivot: Node2D = $WeaponPivot

# ==============================================================================
# SIGNALS
# ==============================================================================
signal dodge_started
signal dodge_ended

# ==============================================================================
# CICLO DE VIDA
# ==============================================================================
func _enter_tree() -> void:
	# adiciona uma etiqueta no nodo quando ele entra na scene tree
	# torna mais fácil pra nodos filhos encontrarem a referência e se conectar aos signals emitidos
	add_to_group("player")

func _ready() -> void:
	super() # conecta o signal do died no método
	
	for w in weapon_manager.weapons:
		w.reload_started.connect(_reload_started)
		w.reload_finished.connect(_hide_reload_bar)
	
	weapon_manager.weapon_changed.connect(_on_weapon_changed)
	
	
func _process(delta: float) -> void:
	if not is_dead:
		weapon_manager.aim_at(get_global_mouse_position())
	
	_handle_weapon_input()
	_update_reloadBar(delta)

# ==============================================================================
# MOVIMENTO
# ==============================================================================
func _update_movement(delta: float) -> void:
	if is_dead or not can_move:
		move_velocity = Vector2.ZERO
		sprite.pause()
		if not is_dead:
			state = State.MOVE # travado não conta como sprint
		return
	
	# movimento WASD
	# get_action_strength retorna um valor entre [0, 1] se a tecla estiver pressionada
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") # -y = cima, +y = baixo
	input_vector = input_vector.normalized()
	
	# tem q ta segurando sprint E se movendo E ter stamina pra drenar
	var sprinting := (not is_dodging
		and Input.is_action_pressed("sprint")
		and input_vector != Vector2.ZERO
		and stamina.drain(sprint_cost, delta))
	
	if not is_dodging:
		state = State.SPRINT if sprinting else State.MOVE
		
	move_velocity = input_vector * get_speed() * (sprint_mult if sprinting else 1.0)
		
	_process_dodge(delta)
	_update_animation()

# ==============================================================================
# ESQUIVA
# ==============================================================================
# não ter i-frames é uma decisão de mecânica. Pelo menos por enquanto (21/08/26)
func _process_dodge(delta: float) -> void:
	var dodge_speed: float = get_speed() * dodge_speed_mult
	# só é possível esquivar enquanto se move
	if input_vector != Vector2.ZERO:
		if Input.is_action_just_pressed("dodge") and can_dodge:
			if not stamina.spend(dodge_cost): 
				# confere o custo da esquiva, se for falso, n tem stamina ent n processa o dodge
				return 
				
			_start_dodge()
		
	if is_dodging:
		# fica imune ao hazard durante um momento do roll. Vai precisar de ajuste
		var progress := 1.0 - (dodge_timer / dodge_duration)   # 0.0 no início, 1.0 no fim
		airborne = progress > 0.3 and progress < 0.7           # quadros centrais

		dodge_timer -= delta
		if dodge_timer <= 0:
			_end_dodge()
		else:
			# só aplica a velocidade da rolagem enquanto ela dura (sem frame extra no final)
			move_velocity = dodge_direction * dodge_speed
	
	if not can_dodge and not is_dodging:
		dodgeCooldown_timer -= delta
		if dodgeCooldown_timer <= 0:
			can_dodge = true

func _start_dodge() -> void:
	dodge_direction = input_vector
	dodge_timer = dodge_duration
	dodgeCooldown_timer = dodge_cooldown
	dodge_started.emit()
	can_dodge = false
	weapon_manager.set_weapon_visibility(false)
	
	if dodge_ignores_knockback:
		knockback_velocity = Vector2.ZERO
	
	state = State.DODGE
	sprite.facing = _get_dodge_animation_direction(input_vector)

func _end_dodge() -> void:
	state = State.MOVE
	airborne = false
	dodge_ended.emit()
	weapon_manager.set_weapon_visibility(true)

func _get_dodge_animation_direction(dir: Vector2) -> String:
	# avalia primeiro a direção X, então rolagens na diagonal usam essa animação
	if dir.x != 0:
		return "right" if dir.x > 0 else "left"
	
	# se só está se movendo em y, retorna cima ou baixo pra disparar essa animação
	return "down" if dir.y > 0 else "up"

# ==============================================================================
# ARMAS / RECARGA
# ==============================================================================

func _handle_weapon_input() -> void:
	# o próprio dono da arma gerencia os blocks do atk com as suas ações
	# ao invés de fazer a arma bloquear via signal igual tava antes.
	if is_dead or is_dodging or not can_move: # not can move garante q o player n atira enquanto o menu lobo estiver aberto
		return
	var weapon := weapon_manager.get_weapon()
	var wants_attack := Input.is_action_pressed("fire") if weapon.automatic else Input.is_action_just_pressed("fire")
	if wants_attack:
		weapon.try_attack()
	if Input.is_action_just_pressed("reload") and weapon is RangedWeapon:
		weapon.try_reload()

# marca _w como privado pq n vai usar o atributo aqui
func _on_weapon_changed(_w: Weapon) -> void:
	_hide_reload_bar()

# TODO (L2): a barra conta o tempo por conta própria. Se a recarga for cancelada
# (troca de arma), barra e arma dessincronizam. Quando a arma emitir um signal de
# fim/cancelamento da recarga, conectar em _hide_reload_bar() no lugar de contar delta
func _reload_started(reload_time: float) -> void:
	reload_bar.value = 0
	reload_bar.min_value = 0
	reload_bar.max_value = reload_time
	reload_bar.visible = true
	is_reloading = true
	
func _update_reloadBar(delta: float) -> void:
	if is_reloading:
		reload_bar.value += delta
		
func _hide_reload_bar() -> void:
	is_reloading = false
	reload_bar.visible = false


# ==============================================================================
# ANIMAÇÃO
# ==============================================================================

func _update_animation() -> void:
	if is_dodging:
		sprite.play_action("dodge")
	else:
		sprite.update_facing(get_global_mouse_position() - global_position)

		# arma atrás do corpo só quando mirando para cima (sem mexer em z_index)
		weapon_pivot.show_behind_parent = (sprite.facing == "up")

		sprite.play_move(input_vector != Vector2.ZERO)

# ==============================================================================
# API PÚBLICA (chamada por outros sistemas)
# ==============================================================================
func set_can_move(value: bool) -> void:
	can_move = value
	if not value and is_dodging:
		# travar movimento cancela a rolagem
		_end_dodge()

# sobrescreve o do Character: a rolagem pode ser imune a empurrão
func apply_knockback(impulse: Vector2) -> void:
	if is_dodging and dodge_ignores_knockback:
		return
	super(impulse)

# ==============================================================================
# MORTE
# ==============================================================================
func _on_died() -> void:
	if is_dodging: _end_dodge()
	state = State.DEAD
	sprite.pause()
	_hide_reload_bar()
	move_velocity = Vector2.ZERO
	weapon_pivot.process_mode = Node.PROCESS_MODE_DISABLED # desabilita a gerência de armas
	weapon_manager.process_mode = Node.PROCESS_MODE_DISABLED

# ==============================================================================
# DEBUG
# ==============================================================================
func _draw() -> void:
	if OS.is_debug_build():
		draw_line(Vector2(-30, 0), Vector2(30, 0), Color.RED, 2.0)
		
# TESTE TEMPORÁRIO (apagar depois)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		hurtbox.take_damage(10)
		hurtbox.apply_knockback(Vector2(400, 0))
		print(health.health)		
