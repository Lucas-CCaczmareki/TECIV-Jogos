extends Weapon

@export var bullet_scene: PackedScene
@onready var tip: Marker2D = $Tip
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var blocked_by_dodge: bool = false
var blocked_by_reload: bool = false # ainda preciso implementar a funcionalidade de reload

# tipo um construtor
func _ready() -> void:
	# conecta as funções que vão escutar os signals
	# nesse caso foi usada uma lambda (função anônima). func(): <código>
	player.dodge_started.connect(func(): blocked_by_dodge = true)
	player.dodge_ended.connect(func(): blocked_by_dodge = false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire") and _can_fire():
		fire()

func _can_fire() -> bool:
	# depois vai empilhando os blockeds com or
	# dessa maneira a própria arma gerencia o disparo
	return not (blocked_by_dodge or blocked_by_reload) 

func fire() -> void:
	var bullet: Node2D = bullet_scene.instantiate()
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	bullet.global_position = tip.global_position
	bullet.global_rotation = global_rotation
	
	# instancia a bala ligada na SceneTree atual
	get_tree().current_scene.add_child(bullet)
	# need to destroy the bullet after some time
	pass
