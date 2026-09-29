extends Node2D

@export var player_scene: PackedScene
@export var level: PackedScene
func _ready() -> void:
	var player = player_scene.instantiate()
	var Level = level.instantiate()
	
	add_child(Level)
	add_child(player)
	pass # Replace with function body.
