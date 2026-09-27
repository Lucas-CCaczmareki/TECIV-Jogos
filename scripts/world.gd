extends Node2D

@export var player_scene: PackedScene
@export var chunks_scene: PackedScene
func _ready() -> void:
	var player = player_scene.instantiate()
	var chunk_manager = chunks_scene.instantiate()
	
	add_child(player)
	add_child(chunk_manager)
	pass # Replace with function body.
