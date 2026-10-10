extends Node2D

@export var enemy1_scene: PackedScene
@onready var slime_pos: Marker2D = $SlimePosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slime = enemy1_scene.instantiate()
	slime.global_position = slime_pos.global_position
	add_child(slime)

	pass # Replace with function body.
