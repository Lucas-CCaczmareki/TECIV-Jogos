extends PlayerWeapon


# Por enquanto usa o _ready e _process padrão
# IDEIA: reload has to be equivalent to how many bullets you can put  
# ex: ammo is 6/8, so the reload time is just for 2 bullets
	
func atk() -> void:
	atk_sfx.play()
	for i in bullets_per_shot:
		var bullet: Node2D = atk_scene.instantiate()
		var half_deg: float = spread_degrees / 2.0
		var bullet_offset: float = deg_to_rad(randf_range(-half_deg, half_deg))
		
		# Faz o sprite da bala nascer na ponta da arma
		bullet.global_position = tip.global_position
		
		# rotacionado de acordo com a arma + rotação de 10 graus pra cima ou 10 pra baixo da bullet
		# simulando comportamento das balas de uma doze
		bullet.global_rotation = global_rotation + bullet_offset
		
		# faz cada bala ter uma velocidade levemente diferente
		# ex de 0.75 (mais lenta) até 1.15 (mais rápida)
		bullet.speed *= randf_range(1.0 - speed_variation, 1.0 + speed_variation)
		
		get_tree().current_scene.add_child(bullet)
		
	ammo = ammo - 1
	ammo_changed.emit(ammo, capacity)
	
	# blocks the next fire
	blocked_by_cooldown = true
	atk_cooldownTimer = atk_cooldown
