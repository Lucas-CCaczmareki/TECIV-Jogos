extends AtkScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	pass

func _process_collision(target: Node2D) -> void:
	if target.has_method("take_damage"):
		target.take_damage(10);
		
		# acho que aqui emite um sinal q acertou pra aumentar o combo count
		#hit.emit()

	pass
