extends Weapon

@export var bullet_scene: PackedScene
@onready var tip: Marker2D = $Tip

# roda quando o objeto foi criado
func _init() -> void:
	capacity = 6 			# defines the maximum ammo capacity of the gun
	fire_cooldown = 0.28 	# defines the cooldown between bullets
	reload_cooldown = 1.5 	# defines the reload cooldown

# tipo um construtor
func _ready() -> void:
	super()
	ammo_changed.emit(ammo, capacity)

	# conecta as funções que vão escutar os signals
	# nesse caso foi usada uma lambda (função anônima). func(): <código>
	player.dodge_started.connect(func(): blocked_by_dodge = true)
	player.dodge_ended.connect(func(): blocked_by_dodge = false)

func _process(delta: float) -> void:
	_fire_cooldown(delta) # 'delta' is the elapsed time since the previous frame.
	_reload_cooldown(delta)
	
	if Input.is_action_just_pressed("fire") and _can_fire():
		fire()
	
	if Input.is_action_just_pressed("reload"):
		_reload() #activate the cooldown to reload and set ammo

func fire() -> void:
	var bullet: Node2D = bullet_scene.instantiate()
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	bullet.global_position = tip.global_position
	bullet.global_rotation = global_rotation
	
	# instancia a bala ligada na SceneTree atual
	get_tree().current_scene.add_child(bullet)
	ammo = ammo - 1
	ammo_changed.emit(ammo, capacity)
	
	# blocks the next fire
	blocked_by_cooldown = true
	fire_cooldownTimer = fire_cooldown
