extends Node2D

@export var player_scene: PackedScene
@export var companion_scene: PackedScene
@export var chunks_scene: PackedScene

@onready var companion_pos: Marker2D = $CompanionPosition

func _ready() -> void:
	var player = player_scene.instantiate()
	var chunk_manager = chunks_scene.instantiate()
	var companion = companion_scene.instantiate()
	
	companion.global_position = companion_pos.global_position
	
	add_child(player)
	add_child(chunk_manager)
	#add_child(companion)
	
	var weapon_pivot = player.get_node("WeaponPivot")
	var weapon = weapon_pivot.get_weapon()
	
	weapon_pivot.weapon_changed.connect($HudManager.bind_weapon)
	$HudManager.bind_weapon(weapon)
	
	pass # Replace with function body.
