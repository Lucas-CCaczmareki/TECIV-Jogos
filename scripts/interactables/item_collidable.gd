class_name ItemCollidable
extends Interactable

signal collected(actor: Node, effect_id: StringName)

@export var effect_id: StringName

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not _can_collect(body):
		return

	interact(body)

func interact(actor: Node) -> void:
	if not enabled or _interacted:
		return

	super.interact(actor)
	collected.emit(actor, effect_id)
	queue_free()

func _can_collect(body: Node) -> bool:
	return body.is_in_group("player") or body.is_in_group("companion")
