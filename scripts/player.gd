extends CharacterBody2D

# @export makes the var controllable with inspector
@export var speed: float = 240.0 
@export var dodge_speed: float = speed*2
@export var dodge_duration: float = 0.60
@export var dodge_cooldown: float = 0.20 # the entire time of dodge_duration + cooldown

var input_vector : Vector2 = Vector2.ZERO # Vector2 is similar to std::pair<float, float>
var last_direction: String = "down" 

var dodge_direction: Vector2 = Vector2.ZERO
var is_dodging: bool = false
var can_dodge: bool = true
var dodge_timer: float = 0
var dodgeCooldown_timer: float = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void: # called ~60x times per sec
	# WASD movement
	# Action strenght will return a value between [0, 1] if pressed
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") # -y = up, + y = down	
	input_vector = input_vector.normalized()
	
	velocity = input_vector * speed # each direction is multiplied by speed
	
	_process_dodge(delta)
	move_and_slide()
	_update_animation()

# no i-frames is a mechanic decision. At least for now (21/08/26)
func _process_dodge(delta: float) -> void:
	# only possible to dodge while moving
	if input_vector != Vector2.ZERO:
		if Input.is_action_just_pressed("dodge") and can_dodge:
			dodge_direction = input_vector
			dodge_timer = dodge_duration
			dodgeCooldown_timer = dodge_cooldown
			is_dodging = true
			can_dodge = false
		
	if is_dodging: 
		dodge_timer -= delta
		if dodge_timer <= 0:
			is_dodging = false
			
		velocity = dodge_direction * dodge_speed
	
	if not can_dodge and not is_dodging:
		dodgeCooldown_timer -= delta
		if dodgeCooldown_timer <= 0:
			can_dodge = true

func _update_animation() -> void:
	if is_dodging:
		sprite.play("dodge_" + last_direction)
	else:
		if input_vector != Vector2.ZERO: # if have movement
			if (input_vector.x == 1 and input_vector.y == 0): 	last_direction = "right"
			if (input_vector.x == -1 and input_vector.y == 0): 	last_direction = "left"
			if (input_vector.x == 0 and input_vector.y == -1): 	last_direction = "up"
			if (input_vector.x == 0 and input_vector.y == 1): 	last_direction = "down"
			sprite.play("walk_" + last_direction)
		else: # is idle
			sprite.play("idle_" + last_direction)
	
