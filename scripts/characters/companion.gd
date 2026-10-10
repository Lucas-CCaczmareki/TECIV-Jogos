extends CharacterBody2D

@export var speed: float = 220.0 
@export var follow_distance: float = 120.0
@export var follows_player: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var direction: Vector2 = Vector2.ZERO
var distance: float = 0.0

var animation_timer: float = 0
var animation_cooldown: float = 0.2
# um tipo de string que usa um comparador interno pra ver se é igual
# ao invés de percorrer tudo. Acelera o processo quando ter várias comparações
var current_animation: StringName = &"" 

# TODO: collision shape should change depending on which animation the companion is having
func _physics_process(delta: float) -> void:
	animation_timer -= delta
	if player == null: return
	
	# permite deixar o companion parado
	if not follows_player:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# this is the same as 
	# gives a Vector2D pointing to player direction
	distance = global_position.distance_to(player.global_position)
	
	if distance > follow_distance:
		# var direction = (player.global_position - global_position).normalized()
		direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO # stops moving
	
	move_and_slide()
	_update_animation()
	
func _update_animation() -> void:
	if velocity == Vector2.ZERO:
		_play(&"idle_down")
		return
	
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			_play(&"walk_right")
		else:
			_play(&"walk_left")
	else:
		if direction.y > 0:
			_play(&"walk_down")
		else:
			_play(&"walk_up")
	
func _play(animation: StringName) -> void:
	if animation == current_animation:
		return # já tá tocando essa n atualiza
	if animation_timer > 0:
		return # ainda tá em cooldown, n troca
	
	current_animation = animation
	animation_timer = 0.0
	sprite.play(animation)
		
