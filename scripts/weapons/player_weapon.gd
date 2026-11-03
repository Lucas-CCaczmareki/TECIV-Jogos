extends RangedWeapon
class_name PlayerWeapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	ammo_changed.emit(ammo, capacity)

	# conecta as funções que vão escutar os signals
	# nesse caso foi usada uma lambda (função anônima). func(): <código>
	wielder.dodge_started.connect(func(): blocked_by_action = true)
	wielder.dodge_ended.connect(func(): blocked_by_action = false)

# utilizada no revolver, smg e sniper
func atk() -> void:
	atk_sfx.play()
	atkInstance = atk_scene.instantiate()
	var half_deg: float = spread_degrees / 2.0
	var bullet_offset: float = deg_to_rad(randf_range(-half_deg, half_deg))
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	atkInstance.global_position = tip.global_position
	atkInstance.global_rotation = global_rotation + bullet_offset
	
	# instancia a bala ligada na SceneTree atual
	atkInstance.set_damage(damage)
	get_tree().current_scene.add_child(atkInstance)
	ammo = ammo - 1
	ammo_changed.emit(ammo, capacity)
	
	# blocks the next fire
	blocked_by_cooldown = true
	atk_cooldownTimer = atk_cooldown

func _atk_action() -> bool:
	return Input.is_action_pressed("fire")

func _reload_action() -> bool:
	return Input.is_action_just_pressed("reload")
