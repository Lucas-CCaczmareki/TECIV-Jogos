extends CharacterBody2D

@export var speed: float = 240.0 #permite controlar ela no inspector
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Guarda pra onde o personagem ficou olhando por último pra saber
#  qual idle tocar quando ele parar de andar
var last_direction: String = "down" 

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("Hello world GODOT!")
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_pressed("ui_right"):
		#print("Segurando S (direita)")
	#pass

func _physics_process(delta: float) -> void:
	# Vector2 é como se fosse um std::pair<float, float>
	# mas ele tem uns métodos úteis pra matemática em jogos.
	# ou usa := Vector2.ZERO. Ai a variável infere o tipo.
	var input_vector : Vector2 = Vector2.ZERO # o .ZERO inicia o nosso Vector2 com (0, 0)
	
	# mudei as ações ui_right etc pra respeitar WASD ao invés das setinhas nas configs do projeto
	# get_action_strength retorna um float entre 0.0 e 1.0 quando a tecla é pressionada ( é + útil pra analógicos, mas funciona )
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# arruma o bug do personagem se mover mais rápido na diagonal.
	# acaba com a desigualdade triangular tho
	input_vector = input_vector.normalized()
	
	# só lembrando q como isso ta dentro do process, é chamado ~60x por segundo
	# aplica velocidade (atributo privado desse node) e move o personagem
	velocity = input_vector * speed
	move_and_slide()
	_update_animation(input_vector)

func _update_animation(input_vector: Vector2) -> void:
	if input_vector != Vector2.ZERO:
		if(input_vector.x == 1 and input_vector.y == 0):
			sprite.play("walk_right")
			last_direction = "right"
		
		if(input_vector.x == -1 and input_vector.y == 0):
			sprite.play("walk_left")
			last_direction = "left"
		
		if(input_vector.x == 0 and input_vector.y == -1):
			sprite.play("walk_up")
			last_direction = "up"
		
		if(input_vector.x == 0 and input_vector.y == 1):
			sprite.play("walk_down")
			last_direction = "down"
		
	else:
		# toca a idle do personagem pra última direção q ele tava olhando
		sprite.play("idle_" + last_direction)
	
