extends AtkScene
class_name Bullet

# comportamento específico da bullet
# ela se move em direção à onde foi disparada
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	pass

func _on_hit(_target: Node2D) -> void:
	queue_free()
