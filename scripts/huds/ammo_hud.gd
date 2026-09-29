extends Control

@onready var ammo_label: Label = $VBoxContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_ammo(current: int, max: int):
	ammo_label.text = "%d/%d" % [current, max]
	pass
