extends MeleeWeapon

@export var slight_mov: float

# só pra eu conseguir testar a melee com o player
var ammo: int
@export var capacity: int
@export var bullets_per_shot: int
signal reload_started(duration: float)
signal ammo_changed(current: int, max: int)

func _ready() -> void:
	super()
	wielder.dodge_started.connect(func(): blocked_by_action = true)
	wielder.dodge_ended.connect(func(): blocked_by_action = false)

func atk() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# memsa lógica do player, pra inimigos muda o cálculo. Só pra testes
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pivot_pos: Vector2 = get_global_position()
	var distance: Vector2 = mouse_pos - pivot_pos
	
	atkInstance = atk_scene.instantiate()
	atkInstance.set_damage(damage)
	atkInstance.set_knockback_force(knockback_force)
	
	if abs(distance.y) >= abs(distance.x):
		if mouse_pos.y < pivot_pos.y: 
			# up, gira o slash pra cima (90 graus)
			#slash.rotation = deg_to_rad(90)
			sprite.z_index = 1 # coloca o sprite do personagem uma layer pra cima
			tween.tween_property(wielder, "position:y", wielder.position.y - slight_mov, atk_cooldown)
		else: 
			# down, gira o slash pra baixo
			#slash.rotation = deg_to_rad(-90)
			sprite.z_index = 0
			tween.tween_property(wielder, "position:y", wielder.position.y + slight_mov, atk_cooldown)
	else: # dist x > dist y
		if mouse_pos.x > pivot_pos.x: 
			# right, gira o slash pra direita
			#slash.rotation = deg_to_rad(180)
			# slash.scale.y *= -1 # flip vertical, faz isso com x é o horizontal
			sprite.z_index = 0
			tween.tween_property(wielder, "position:x", wielder.position.x + slight_mov, atk_cooldown)
		else: 
			# left é o padrão, n faz nada
			sprite.z_index = 0
			tween.tween_property(wielder, "position:x", wielder.position.x - slight_mov, atk_cooldown)
	
	# as rotações e posições da atk scene vem depois do movimento do personagem
	atkInstance.global_position = tip.global_position
	atkInstance.global_rotation = tip.global_rotation
	#atkInstance.scale.x *= -1
	#slash.hit.connect(_combo_count, CONNECT_ONE_SHOT)
	
	var animation: AnimatedSprite2D = atkInstance.get_node("Area2D/AnimatedSprite2D")
	animation.play("slash_" + str(combo_count))
		
	get_tree().current_scene.add_child(atkInstance)
	
	blocked_by_cooldown = true
	atk_cooldownTimer = atk_cooldown

func _atk_action() -> bool:
	return Input.is_action_just_pressed("fire")
