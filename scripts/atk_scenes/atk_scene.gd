extends Node2D
class_name AtkScene

# TODO: Preciso implementar lifetime das bullets
@export var speed: float = 500.0
@export var max_range: float = 1200
@export var lifetime: float = 2.0
var damage: float
var knockback_force: float

@onready var direction: Vector2 = transform.x # me retorna um vetor normalizado na mesma direção do eixo x da bullet em relação ao mundo
@onready var collision: Area2D = $Area2D
@onready var sprite: Sprite2D = $Area2D/Sprite2D
@onready var col_shape: CollisionShape2D = $Area2D/CollisionShape2D

#signal hit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect this signal with the function
	collision.body_entered.connect(_process_collision)
	
	# cria um tween pra dar queue_free na attackscene com base no lifetime
	var tween_lifetime = create_tween()
	tween_lifetime.tween_interval(lifetime)
	tween_lifetime.tween_callback(queue_free)
	pass

# O próprio node Area2D da bullet scene dispara o sinal e envia como parãmetro 
# o nodo que entrou na área de colisão da bullet

# it's necessary to receive the node as a parameter because is sent by the signal
# if not received, it will launch an error. It sends the body/area you collided
func _process_collision(target: Node2D) -> void:
	#hit.emit()
	_apply_effects(target)
	_on_hit(target)
	pass

func _apply_effects(target: Node2D) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
		
	if target.has_method("apply_knockback"):
		# simplesmente multiplica a direção (1,0) pela força (200) -> (200,0)
		target.apply_knockback(direction * knockback_force)

func _on_hit(_target: Node2D) -> void:
	pass

func set_damage(dmg: float) -> void:
	damage = dmg
	
func set_knockback_force(force: float) -> void:
	knockback_force = force
