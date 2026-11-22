extends RangedWeapon
class_name PlayerWeapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	#automatic = true
	ammo_changed.emit(ammo, capacity)

# utilizada no revolver, smg e sniper
func atk() -> void:
	atk_sfx.play()
	atkInstance = atk_scene.instantiate()
	var half_deg: float = spread_degrees / 2.0
	var bullet_offset: float = deg_to_rad(randf_range(-half_deg, half_deg))
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	atkInstance.global_position = tip.global_position
	atkInstance.global_rotation = global_rotation + bullet_offset
	
	# passa os atributos necessários pra atk scene
	atkInstance.set_damage(damage)
	atkInstance.set_knockback_force(knockback_force)
	atkInstance.set_target_mask(target_mask)
	
	# instancia a bala ligada na SceneTree atual
	_spawn_atk(atkInstance)
	ammo = ammo - 1
	ammo_changed.emit(ammo, capacity)
	
	# blocks the next fire
	blocked_by_cooldown = true
	atk_cooldownTimer = atk_cooldown
