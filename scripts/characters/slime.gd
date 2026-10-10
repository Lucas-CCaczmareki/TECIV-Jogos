extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var life: int = 20

@export var hurtAnimation_duration: 	 float = 0.50
var 		animation_timer: 		 float = 0
var was_hurt: bool = false

func _physics_process(delta: float) -> void:
	if was_hurt:
		animation_timer -= delta
		sprite.play("hurt")
		
		if animation_timer <= 0:
			was_hurt = false
			print(life)
			if life <= 0:
				queue_free()
	else:
		sprite.play("idle")
	
func take_damage(damage: int) -> void:
	life -= damage
	was_hurt = true;
	animation_timer = hurtAnimation_duration
	
