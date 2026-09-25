extends Node2D
class_name ChunkManager

@export var initial_chunk: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chunk: Node2D = initial_chunk.instantiate()
	add_child(chunk)
