extends Enemy
class_name Slime

@export var hurt_animation_duration: float = 0.5
@export var contact_cooldown: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $Hitbox

var _contact_timer: float = 0.0
var animation_timer: float = 0.0
var was_hurt: bool = false

func _ready() -> void:
	super()
	hitbox.enable()


func _update_movement(delta: float) -> void:
	super(delta)

	_contact_timer -= delta

	if _contact_timer <= 0.0:
		hitbox.hit_overlapping_areas()
		_contact_timer = contact_cooldown

	if was_hurt:
		animation_timer -= delta
		sprite.play("hurt")

		if animation_timer <= 0.0:
			was_hurt = false
	else:
		sprite.play("idle")


func take_damage(amount: int) -> void:
	super(amount)

	if state == State.DEAD:
		return

	was_hurt = true
	animation_timer = hurt_animation_duration
