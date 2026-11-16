class_name Door
extends Interactable

signal opened

@export var blocking_body_path: NodePath = ^"BlockingBody"

@export var blocking_body: StaticBody2D
@export var open_animation: StringName = &"open"
@export var closed_animation: StringName = &"closed"

var _player: Node2D # só definido enquanto o player estiver na área

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _interaction_prompt: Label = $InteractionPrompt

func _ready() -> void:
	blocking_body = get_node_or_null(blocking_body_path) as StaticBody2D
	if blocking_body == null:
		push_error("Door '%s' precisa de um blocking_body." % name)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	set_process_unhandled_input(false) # só liga com o player por perto
	_update_prompt()

	if _animated_sprite.sprite_frames.has_animation(closed_animation):
		_animated_sprite.play(closed_animation)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		interact(_player)

func open() -> void:
	interact(null)

func interact(actor: Node) -> void:
	if not enabled or _interacted:
		return

	super.interact(actor)
	_set_open_state()
	opened.emit()

func _set_open_state() -> void:
	enabled = false
	monitorable = false

	if blocking_body != null:
		blocking_body.set_deferred("collision_layer", 0)
		blocking_body.set_deferred("collision_mask", 0)

	if _animated_sprite.sprite_frames.has_animation(open_animation):
		_animated_sprite.play(open_animation)

	_player = null
	set_process_unhandled_input(false)
	_update_prompt()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body
		set_process_unhandled_input(enabled)
		_update_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
		set_process_unhandled_input(false)
		_update_prompt()

func _update_prompt() -> void:
	if is_instance_valid(_interaction_prompt):
		_interaction_prompt.visible = enabled and _player != null
