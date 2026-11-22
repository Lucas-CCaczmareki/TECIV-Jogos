extends Character

# ==============================================================================
# AJUSTES (editáveis no Inspector)
# ==============================================================================
@export var follow_distance: float = 120.0

# estados do TDD (08). Por enquanto só FOLLOW, HOLD e DEAD têm comportamento:
# ATTACK entra no L8 (golpe com Hitbox) e COMMANDED no L9 (menu do lobo).
enum State { FOLLOW, COMMANDED, ATTACK, HOLD, DEAD }
@export var state: State = State.FOLLOW # permite deixar o companion parado (HOLD) pelo Inspector pra testar

@export var weapon_pivot: WeaponPivot
@export var weapon_scene: PackedScene

# ==============================================================================
# NÓS
# ==============================================================================
@onready var sprite: DirectionalSprite = $Sprite
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var atk_sfx: AudioStreamPlayer = $AttackSound

# ==============================================================================
# CICLO DE VIDA
# ==============================================================================
func _ready() -> void:
	super() # conecta o signal do died no método
	# TODO: não tá funcionando, vou ter que arrumar. Enfim, ver oq tem que fazer agr
	# acho que o principal é começar a focar nos scripts dos personagens ou das atk scenes
	# e fazer as classes separadinhas direito
	
	#var weapon := weapon_scene.instantiate()
	#weapon_pivot.add_child(weapon)
	#weapon_pivot.set_aim(player.global_position)
	#weapon_pivot.set_aim(get_global_mouse_position())
	pass

# ==============================================================================
# MOVIMENTO
# ==============================================================================
# TODO: collision shape should change depending on which animation the companion is having
# TODO: o weapon pivot também vai ter que mudar dependendo de pra que lado o companion tá
func _update_movement(_delta: float) -> void:
	match state:
		State.FOLLOW:
			_follow_player()
		_: # outros estados
			# HOLD, ATTACK, COMMANDED e DEAD: parado por enquanto
			move_velocity = Vector2.ZERO
	
	# morto não atualiza animação (o sprite fica parado, ver _on_died)
	if state != State.DEAD:
		sprite.update_facing(move_velocity)
		sprite.play_move(move_velocity != Vector2.ZERO)

func _follow_player() -> void:
	if player == null:
		move_velocity = Vector2.ZERO
		return
	
	# this is the same as 
	# dá um Vector2 apontando pra direção do player
	var distance: float = global_position.distance_to(player.global_position)
	
	if distance > follow_distance:
		# var direction = (player.global_position - global_position).normalized()
		var direction: Vector2 = global_position.direction_to(player.global_position)
		move_velocity = direction * get_speed()
	else:
		move_velocity = Vector2.ZERO # para de se mover

# ==============================================================================
# MORTE
# ==============================================================================
func _on_died() -> void:
	state = State.DEAD
	move_velocity = Vector2.ZERO
	sprite.pause()
