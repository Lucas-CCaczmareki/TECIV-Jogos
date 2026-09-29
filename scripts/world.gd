extends Node2D

@export var player_scene: PackedScene
@export var chunks_scene: PackedScene
func _ready() -> void:
	var player = player_scene.instantiate()
	var Level = chunks_scene.instantiate()
	
	add_child(Level)
	add_child(player)
	pass # Replace with function body.
