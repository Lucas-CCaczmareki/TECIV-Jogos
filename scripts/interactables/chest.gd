extends Area2D
class_name Chest

signal collected(actor: Node, reward_type: RewardType, reward_id: StringName, amount: float)

enum RewardType {WEAPON, POWER_UP}

@export var reward_type: RewardType = RewardType.WEAPON
@export var reward_id: StringName
@export var amount: float = 1.0
@export var open_animation: StringName = &"open"

var is_collected := false
var _player: Node2D
var _input_down := false

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _prompt: Label = $InteractionPrompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_prompt.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo():
		if not _input_down:
			_input_down = true
			if _player != null and not is_collected:
				_collect()
				get_viewport().set_input_as_handled()
	elif event.is_action_released("interact"):
		_input_down = false

func _collect() -> void:
	is_collected = true
	monitoring = false
	_prompt.hide()
	collected.emit(_player, reward_type, reward_id, amount)

	if _animated_sprite.sprite_frames.has_animation(open_animation):
		_animated_sprite.play(open_animation)
		await _animated_sprite.animation_finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_collected:
		_player = body
		_prompt.show()

func _on_body_exited(body: Node2D) -> void:
	if body == _player:
		_player = null
		_prompt.hide()


func _draw() -> void:
	if OS.is_debug_build():
		draw_line(Vector2(-30, 0), Vector2(30, 0), Color.RED, 2.0)
