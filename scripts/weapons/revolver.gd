extends Weapon

@export var bullet_scene: PackedScene
@onready var tip: Marker2D = $Tip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		fire()

# NEED FIX: bullet is following the rotation of the 
func fire() -> void:
	var bullet: Node2D = bullet_scene.instantiate()
	
	# Faz o sprite da bala nascer na ponta da arma e rotacionado de acordo com a arma
	bullet.global_position = tip.global_position
	bullet.global_rotation = global_rotation
	
	# instancia a bala ligada na SceneTree atual
	get_tree().current_scene.add_child(bullet)
	# need to destroy the bullet after some time
	pass
