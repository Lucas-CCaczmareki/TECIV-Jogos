extends Camera2D

func _ready() -> void:
	Events.camera_bounds_changed.connect(_on_bounds_changed)

func _on_bounds_changed(b: Rect2) -> void:
	limit_left = int(b.position.x)
	limit_top = int(b.position.y)
	limit_right = int(b.end.x)
	limit_bottom = int(b.end.y)
