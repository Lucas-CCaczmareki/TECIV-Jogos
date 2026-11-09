extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var life: int = 35

@export var hurtAnimation_duration: 	 float = 0.50
var 		animation_timer: 		 float = 0
var was_hurt: bool = false

# TODO: depois da uma lida nesse sistema de knockback
var knockback_velocity: Vector2 = Vector2.ZERO
@export var knockback_friction: float = 600.0
@export var knockback_resistance: float = 0.0   # 0 = normal, 1 = imune (bosses)

func _physics_process(delta: float) -> void:
	if was_hurt:
		animation_timer -= delta
		sprite.play("hurt")
		
		if animation_timer <= 0:
			was_hurt = false
			if life <= 0:
				queue_free()
	else:
		sprite.play("idle")
		
	var move_velocity: Vector2 = Vector2.ZERO   # quando tiver IA, ela entra aqui
	
	## de.move_toward(para, passo)
	# quer ir pro 0,0 por que é um empurrao que para em algum momento
	# como isso roda a cada frame, ele vai indo pra 0 a cada frame
	# o friction é esse atrito do slime com o chão (o quão pesado ele é)
	# o cálculo com delta entra aqui pra unidade de movimento variar em frames ao invés de segundos
		# mesmo papo de acabar rodando mais rápido em alguns computadores
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	
	# somar vetores é combinar direções, então quando combina o movimento com o knockback
	# eles já se somam/anulam automaticamente
	velocity = move_velocity + knockback_velocity
	move_and_slide()
	
func take_damage(damage: int) -> void:
	life -= damage
	was_hurt = true;
	animation_timer = hurtAnimation_duration
	
func apply_knockback(impulse: Vector2) -> void:
	knockback_velocity = impulse * (1.0 - knockback_resistance)

	
	
