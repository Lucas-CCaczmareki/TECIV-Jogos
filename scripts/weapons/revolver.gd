extends Weapon

@export var bullet_scene: PackedScene
@onready var tip: Marker2D = $Tip

# tipo um construtor
func _ready() -> void:
	capacity = 6
	ammo = capacity # set the revolver ammo to six bullets
	fire_cooldown = 0.28 # define o cooldown entre disparos
	reload_cooldown = 3.5 # defines the reload cooldown
	
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

# TODO: need to destroy the bullet after some time
func fire() -> void:
	var bullet: Node2D = bullet_scene.instantiate()
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	bullet.global_position = tip.global_position
	bullet.global_rotation = global_rotation
	
	# instancia a bala ligada na SceneTree atual
	get_tree().current_scene.add_child(bullet)
	ammo = ammo - 1
	
	# blocks the next fire
	blocked_by_cooldown = true
	fire_cooldownTimer = fire_cooldown
