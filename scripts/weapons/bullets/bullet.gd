extends Node2D

@export var direction: Vector2
@export var speed: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = transform.x
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	pass
