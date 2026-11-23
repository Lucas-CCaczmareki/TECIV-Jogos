extends Character
class_name Enemy

enum State { IDLE, CHASE, ATTACK, STUN, DEAD }
var state: State = State.IDLE # variavel state inicia idle

@export var detection_range: float = 1400.0
@export var lose_range_mult: float = 1.5 # só larga o alvo além de detection_range * isso (evita ficar alternando)
@export var path_refresh: float = 0.2 # de quanto em quanto tempo (s) recalcula a rota
@export var repath_distance: float = 8.0

var _has_path_target: bool = false
var nav_agent: NavigationAgent2D
var _path_timer: float = 0.0
var taunt_target: Node2D = null # skill Atrair do lobo seta isso
var target: Node2D = null
var vision_ray: RayCast2D

func _ready() -> void:
	super()
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("enemy") # cria um group chamado enemies
	
	# raio de visão criado por código (evita configurar o nó em toda cena de inimigo)
	vision_ray = RayCast2D.new() # usado pra desviar de obstáculos
	vision_ray.collision_mask = 1 	 # só enxerga o mundo (a princípio)
	add_child(vision_ray)
	
	nav_agent = NavigationAgent2D.new()
	nav_agent.path_desired_distance = 3.0 # diz o quao perto do ponto da rota conta como ter chegado
	nav_agent.target_desired_distance = 8.0
	
	nav_agent.debug_enabled = true
	add_child(nav_agent)
	
#func _physics_process(delta: float) -> void:
	#super(delta)
#
	##if state != State.CHASE:
		##return
#
	#if Engine.get_physics_frames() % 30 != 0:
		#return
#
	#print(
		#" pos=", global_position,
		#" index=", nav_agent.get_current_navigation_path_index(),
		#" desejada=", move_velocity,
		#" real=", get_real_velocity(),
		#" knockback=", knockback_velocity,
		#" colisoes=", get_slide_collision_count(),
		#" state=", State.keys()[state],
		#" target=", target,
		#" finished=", nav_agent.is_navigation_finished(),
	#)
#
	#for i in range(get_slide_collision_count()):
		#var collision := get_slide_collision(i)
		#print(
			#" collider=", collision.get_collider(),
			#" normal=", collision.get_normal()
		#)	
	
func _update_movement(delta: float) -> void:
	
	#if Engine.get_physics_frames() % 30 == 0: # ~2x por segundo
		#print("state=", state, " target=", target, " finished=", nav_agent.is_navigation_finished(), " path_pts=", nav_agent.get_current_navigation_path().size())
		
	_path_timer -= delta
	# se tá morto n se move
	if state == State.DEAD:
		move_velocity = Vector2.ZERO
		return
	# se tá vivo...
	target = _pick_target()
	
	# máquina de estados
	match state:
		State.IDLE:
			move_velocity = Vector2.ZERO
			# vê o alvo (distância + raio)? Começa a perseguir
			if target and _can_see(target):
				state = State.CHASE
		State.CHASE:
			if target == null or global_position.distance_to(target.global_position) > detection_range * lose_range_mult:
				state = State.IDLE
				move_velocity = Vector2.ZERO
				_has_path_target = false
				return
			_move_toward(target.global_position)
		_: # ATTACK e STUN: ATTACK entra no L6 (alcance muda por tipo), STUN no passo 5
			move_velocity = Vector2.ZERO
	
func _pick_target() -> Node2D:
	# se ta com taunt, retorna ele de alvo
	if is_instance_valid(taunt_target):
		return taunt_target
	
	var best_target: Node2D = null
	var best_dist: float = INF
		
	var targets := get_tree().get_nodes_in_group("player") + get_tree().get_nodes_in_group("companion")
	
	# calcula pro player/companion a distância
	# comportamento padrão, se n ta com taunt, foca oq ta mais perto
	for t in targets:
		# calcula a distância (pitágoras) sem fazer o quadrado pra poupar processamento
		var dist := global_position.distance_squared_to(t.global_position)
		if dist < best_dist:
			best_dist = dist
			best_target = t
			
	return best_target

# percepção: dentro do alcance E sem parede no meio
func _can_see(t: Node2D) -> bool:
	var to := t.global_position - global_position
	if to.length() > detection_range:
		return false
		
	vision_ray.target_position = vision_ray.to_local(t.global_position)
	vision_ray.force_raycast_update() # atualiza o raio agora, não no próximo frame de física
	return not vision_ray.is_colliding() # se colide c/ parede no caminho, retorna false
	
# vai até pos seguindo a rota da malha. Cada tipo de inimigo só escolhe o destino
func _move_toward(pos: Vector2) -> void:
	# 1o frame: o mapa de navegação ainda não sincronizou, vai em linha reta
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		move_velocity = Vector2.ZERO
		return

	# Só recalcula se o alvo mudou suficientemente de posição
	if not _has_path_target or _path_timer <= 0.0:
		if not _has_path_target or nav_agent.target_position.distance_to(pos) >= repath_distance:
			nav_agent.target_position = pos
			_has_path_target = true

		_path_timer = path_refresh
	
	var next_pos := nav_agent.get_next_path_position()
	
	if nav_agent.is_navigation_finished():
		move_velocity = Vector2.ZERO
		return

	var offset := next_pos - global_position
	var delta := get_physics_process_delta_time()

	move_velocity = (offset / delta).limit_length(get_speed())

func _on_died() -> void:
	state = State.DEAD
	queue_free() # placeholder por enquanto, n droppa item e etc. Dps adiciona aq
