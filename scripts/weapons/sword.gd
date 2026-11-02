extends MeleeWeapon

@export var slight_mov: float
var slash: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $Sprite2D
	pass # Replace with function body.


func _atk_cooldown(delta: float) -> void:
	if blocked_by_cooldown:
		atk_cooldownTimer -= delta
		if atk_cooldownTimer <= 0:
			blocked_by_cooldown = false
			
			# TODO: eu preciso padronizar se weapon q cuida de acabar a atk scene ou se a atk scene se tira da arvore mesmo
			slash.queue_free()  
			wielder.set_can_move(true)

func atk() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# memsa lógica do player, pra inimigos muda o cálculo. Só pra testes
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pivot_pos: Vector2 = get_global_position()
	var distance: Vector2 = mouse_pos - pivot_pos
	
	slash = atk_scene.instantiate()
	slash.set_damage(damage)
	
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
	slash.global_position = tip.global_position
	slash.global_rotation = tip.global_rotation
	slash.scale.x *= -1
	#slash.hit.connect(_combo_count, CONNECT_ONE_SHOT)
	
	var animation: AnimatedSprite2D = slash.get_node("Area2D/AnimatedSprite2D")
	animation.play("slash_" + str(combo_count))
		
	get_tree().current_scene.add_child(slash)
	
	blocked_by_cooldown = true
	atk_cooldownTimer = atk_cooldown
