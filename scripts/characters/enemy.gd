extends Character
class_name Enemy

enum State { IDLE, CHASE, ATTACK, STUN, DEAD }
var state: State = State.IDLE # variavel state inicia idle

@export var detection_range: float = 1400.0
@export var lose_range_mult: float = 1.5 # só larga o alvo além de detection_range * isso (evita ficar alternando)
@export var avoid_distance: float = 40.0 # o quão à frente o raio olha pra desviar de parede. Maior que o raio do corpo


var taunt_target: Node2D = null # skill Atrair do lobo seta isso
var target: Node2D = null
var vision_ray: RayCast2D

func _ready() -> void:
	super()
	add_to_group("enemies") # cria um group chamado enemies
	
	# raio de visão criado por código (evita configurar o nó em toda cena de inimigo)
	vision_ray = RayCast2D.new() # usado pra desviar de obstáculos
	vision_ray.collision_mask = 1 	 # só enxerga o mundo (a princípio)
	add_child(vision_ray)
	
func _update_movement(_delta: float) -> void:
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
			# sem alvo ou alvo muito longe: desiste
			if target == null or global_position.distance_to(target.global_position) > detection_range * lose_range_mult:
				state = State.IDLE
				move_velocity = Vector2.ZERO
				return
			var dir := global_position.direction_to(target.global_position)
			move_velocity = _steer(dir) * get_speed()
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
		
	vision_ray.target_position = to # coordenada local (ok porque o inimigo não gira)
	vision_ray.force_raycast_update() # atualiza o raio agora, não no próximo frame de física
	return not vision_ray.is_colliding() # se colide c/ parede no caminho, retorna false

# desvio de parede com o raio: devolve a primeira direção livre.
# Se todas baterem, devolve a que tem mais espaço até a parede (em vez de empurrar de frente)
func _steer(dir: Vector2) -> Vector2:
	var best_dir := dir
	var best_clear := -1.0
	for angle in [0.0, 0.7, -0.7, 1.4, -1.4]: # radianos
		var d := dir.rotated(angle)
		vision_ray.target_position = d * avoid_distance
		vision_ray.force_raycast_update()
		if not vision_ray.is_colliding():
			return d
		# bateu: guarda a direção com mais espaço livre
		var clear := global_position.distance_to(vision_ray.get_collision_point())
		if clear > best_clear:
			best_clear = clear
			best_dir = d
	return best_dir

func _on_died() -> void:
	state = State.DEAD
	queue_free() # placeholder por enquanto, n droppa item e etc. Dps adiciona aq
