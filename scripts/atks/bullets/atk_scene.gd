extends Node2D
class_name AtkScene

# TODO: Preciso implementar lifetime das bullets
@export var direction: Vector2
@export var speed: float = 500.0
@onready var collision: Area2D = $Area2D

@onready var damage: float
@onready var knockback_force: float

#signal hit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect this signal with the function
	collision.body_entered.connect(_process_collision)
	
	# me retorna um vetor normalizado apontando pra mesma direção do eixo x
	# da scene da bullet, só que em relação ao mundo.
	direction = transform.x 
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	pass

# O próprio node Area2D da bullet scene dispara o sinal e me envia como parãmetro 
# o nodo que entrou na área de colisão

# it's necessary to receive the node as a parameter because is sent by the signal
# if not received, it will launch an error. It sends the body/area you collided
func _process_collision(target: Node2D) -> void:
	# remove o nodo do script e seus filhos
	if target.has_method("take_damage"):
		#print("dmg: ", damage)
		target.take_damage(damage);
	
	if target.has_method("apply_knockback"):
		# simplesmente multiplica a direção (1,0) pela força (200) -> (200,0)
		target.apply_knockback(direction * knockback_force)
	
		#hit.emit()
	queue_free();	
	pass
	
func set_damage(dmg: float) -> void:
	damage = dmg
	
func set_knockback_force(force: float) -> void:
	knockback_force = force
