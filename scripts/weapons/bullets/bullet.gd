extends Node2D

@export var direction: Vector2
@export var speed: float = 500.0
@onready var collision: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect this signal with the function
	collision.body_entered.connect(_process_collision)
	direction = transform.x
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	pass

# it's necessary to receive the node as a parameter because is sent by the signal
# if not received, it will launch an error. It sends the body/area you collided
func _process_collision(target: Node2D) -> void:
	# remove o nodo do script e seus filhos
	if target.has_method("take_damage"):
		target.take_damage(10);
	queue_free();
	pass
