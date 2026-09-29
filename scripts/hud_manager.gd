extends CanvasLayer

@export var ammo_hud_scene: PackedScene
var ammo_hud: Control

func _ready() -> void:
	ammo_hud = ammo_hud_scene.instantiate()
	add_child(ammo_hud)

func _process(delta: float) -> void:
	pass
