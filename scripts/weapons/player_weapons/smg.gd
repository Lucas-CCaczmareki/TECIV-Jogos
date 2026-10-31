extends PlayerWeapon

# usa o _ready e _process padrão da super classe PlayerWeapon

func atk() -> void:
	atk_sfx.play()
	var bullet: Node2D = atk_scene.instantiate()
	var half_deg: float = spread_degrees / 2.0
	var bullet_offset: float = deg_to_rad(randf_range(-half_deg, half_deg))
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	bullet.global_position = tip.global_position
	bullet.global_rotation = global_rotation + bullet_offset
	
	# instancia a bala ligada na SceneTree atual
	get_tree().current_scene.add_child(bullet)
	ammo = ammo - 1
	ammo_changed.emit(ammo, capacity)
	
	# blocks the next fire
	blocked_by_cooldown = true
	atk_cooldownTimer = atk_cooldown
