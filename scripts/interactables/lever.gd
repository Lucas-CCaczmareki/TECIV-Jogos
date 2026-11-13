extends Area2D

signal toggled(is_on: bool)

enum State { OFF, ON }

@export var state: State = State.OFF
@export var off_animation: StringName = &"default"
@export var on_animation: StringName = &"open"

var _player: Node2D
var _input_down := false

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _prompt: Label = $InteractionPrompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_visual()
	_update_prompt()

func _unhandled_input(event: InputEvent) -> void:
	# Guarda o pressionamento para não repetir enquanto E estiver segurado.
	if event.is_action_pressed("interact") and not event.is_echo():
		if not _input_down:
			_input_down = true
			if _player != null:
				state = State.ON if state == State.OFF else State.OFF
				_update_visual()
				toggled.emit(state == State.ON)
				get_viewport().set_input_as_handled()
	elif event.is_action_released("interact"):
		_input_down = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player = body
		_update_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
		_update_prompt()

func _update_visual() -> void:
	var animation := on_animation if state == State.ON else off_animation
	if _animated_sprite.sprite_frames.has_animation(animation):
		_animated_sprite.play(animation)

func _update_prompt() -> void:
	_prompt.visible = _player != null
