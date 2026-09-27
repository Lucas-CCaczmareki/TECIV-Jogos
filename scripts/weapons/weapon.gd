extends Node2D
class_name Weapon

func set_visibility(visibility: bool) -> void:
	visible = visibility

func fire() -> void:
	print("does nothing. must be overwritten")
