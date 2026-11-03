extends AtkScene

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
