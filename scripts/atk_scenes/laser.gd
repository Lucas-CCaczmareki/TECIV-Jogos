extends AtkScene

@onready var ray: RayCast2D = $RayCast2D

# TODO: projetar sistema de max_range/lifetime pra bullets
@export var thickness: float = 7.5
var length: float = 0.0

func _ready() -> void:
	super() # WeaponPivot já rotaciona em direção ao mouse, e direction pega esse vetor de rotação
	var target = get_global_mouse_position()
	
	# me da o comprimento (em pixels de mundo) 
	# que vai da tip da arma (lugar onde a bullet é instanciada) até o mouse position. 
	length = (target - global_position).length() 
	length = length if length < max_range else max_range # limita à max range
	
	# limita até colidir com as paredes
	ray.exclude_parent = true
	ray.target_position = Vector2(length, 0.0)
	ray.force_raycast_update()

	if ray.is_colliding():
		length = min(length, ray.global_position.distance_to(ray.get_collision_point()))
	
	## Instanciando o sprite
	var sprite_size: Vector2 = sprite.texture.get_size() 
	sprite.centered = false # ancora no canto superior esquerdo

	# A scale modifica o quanto o sprite cresce (ou estica. Igual as propriedade de CG)
	# a regra é: length = sprite_size.x * scale. O bag é só uma inversão de fórmula
	sprite.scale = Vector2(length / sprite_size.x, thickness / sprite_size.y)
	
	# sobe o sprite metade da thickness pra cima.
	# isso alinha a metade vertical do sprite com o tip da arma
	sprite.position = Vector2(0.0, -thickness / 2)
	
	## Área de colisão
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(length, thickness)
	col_shape.shape = shape
	
	# por que ele sempre inicia centralizado, ent precisa mover pra frente
	# pra acompanhar o sprite
	col_shape.position = Vector2(length / 2.0, 0.0)
	
	# tween faz uma interpolação de um valor a outro, ou espera um intervalo pra fazer alguma coisa	
	## Desligar a colisão (janela curta de tempo, simula hitscan)
	var tween_colision = create_tween()
	tween_colision.tween_interval(0.1)
	tween_colision.tween_callback(col_shape.set_deferred.bind("disabled", true))	
	
	## Fadeout do tiro
	var tween_fade = create_tween()
	tween_fade.tween_property(self, "modulate:a", 0.0, 0.2)
	tween_fade.tween_callback(self.queue_free)
	
# a bala "laser" não se move
func _physics_process(_delta: float) -> void:
	pass

func _on_hit(_target: Node2D) -> void:
	pass
