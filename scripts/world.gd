extends Node2D

@export var player_scene: PackedScene
@export var level: PackedScene
@export var chunks_scene: PackedScene

func _ready() -> void:
	var player = player_scene.instantiate()
	var Level = level.instantiate()
	
	add_child(Level)
	add_child(player)
	add_child(chunk_manager)
	
	var weapon_pivot = player.get_node("WeaponPivot")
	var weapon = weapon_pivot.get_weapon()
	
	weapon.ammo_changed.connect($HudManager.ammo_hud._update_ammo)
	
	
	pass # Replace with function body.
