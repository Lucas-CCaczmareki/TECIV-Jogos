class_name Door
extends Interactable

signal opened

@export var blocking_body_path: NodePath = ^"BlockingBody"

var _blocking_body: StaticBody2D

func _ready() -> void:
	_blocking_body = get_node_or_null(blocking_body_path) as StaticBody2D
	if _blocking_body == null:
		push_error("Door requires a StaticBody2D at '%s'." % blocking_body_path)

func open() -> void:
	if not enabled or _interacted:
		return

	interact(null)

func interact(_actor: Node) -> void:
	if not enabled or _interacted:
		return

	super.interact(_actor)
	_set_open_state()
	opened.emit()

func _set_open_state() -> void:
	enabled = false
	monitoring = false
	monitorable = false

	if _blocking_body != null:
		_blocking_body.set_deferred("collision_layer", 0)
		_blocking_body.set_deferred("collision_mask", 0)
		for child in _blocking_body.get_children():
			if child is CollisionShape2D or child is CollisionPolygon2D:
				child.set_deferred("disabled", true)
