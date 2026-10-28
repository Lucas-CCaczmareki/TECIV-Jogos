class_name Interactable
extends Area2D

signal interacted(actor: Node)

@export var enabled := true

var _interacted := false

func interact(actor: Node) -> void:
	if not enabled or _interacted:
		return

	_interacted = true
	interacted.emit(actor)

func reset_interaction() -> void:
	_interacted = false
