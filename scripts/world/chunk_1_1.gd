extends Node2D

@export var slime_scene: PackedScene
@export var nav_agent_radius_px: float = 12.0 # folga das paredes, em pixels do mundo

func _ready() -> void:
	# TODO: no futuro, agrupar todos os markers sobre um nó
	# pra organizar melhor. Se achar necessário (ai muda o jeito q esse for funciona)
	for child in get_children():
		if child.name.begins_with("SlimePosition"):
			var slime: Node2D = slime_scene.instantiate()
			add_child(slime)
			slime.global_position = child.global_position
	_setup_navigation()

func _setup_navigation() -> void:
	var ground: TileMapLayer = $Ground
	var walls: TileMapLayer = $Walls

	var region := NavigationRegion2D.new()
	add_child(region)

	# chão = área andável; paredes = obstáculo. A união/diferença é feita no bake
	var data := NavigationMeshSourceGeometryData2D.new()
	for outline in _layer_outlines(ground, region):
		data.add_traversable_outline(outline)
	for outline in _layer_outlines(walls, region):
		data.add_obstruction_outline(outline)

	var poly := NavigationPolygon.new()
	poly.agent_radius = nav_agent_radius_px / global_scale.x # a chunk tem escala 5
	NavigationServer2D.bake_from_source_geometry_data(poly, data)
	region.navigation_polygon = poly

# agrupa as células de uma TileMapLayer em "corridas" horizontais (1 retângulo por corrida)
# e devolve os contornos no espaço local da region
func _layer_outlines(layer: TileMapLayer, region: Node2D) -> Array[PackedVector2Array]:
	var outlines: Array[PackedVector2Array] = []
	var rows := {}
	for cell in layer.get_used_cells():
		if not rows.has(cell.y):
			rows[cell.y] = []
		rows[cell.y].append(cell.x)

	for y in rows:
		var xs: Array = rows[y]
		xs.sort()
		var start: int = xs[0]
		var prev: int = xs[0]
		for i in range(1, xs.size() + 1):
			if i == xs.size() or xs[i] != prev + 1:
				outlines.append(_run_outline(layer, region, start, prev, y))
				if i < xs.size():
					start = xs[i]
			if i < xs.size():
				prev = xs[i]
	return outlines

func _run_outline(layer: TileMapLayer, region: Node2D, x0: int, x1: int, y: int) -> PackedVector2Array:
	var ts := Vector2(layer.tile_set.tile_size)
	var tl := layer.map_to_local(Vector2i(x0, y)) - ts / 2.0
	var br := layer.map_to_local(Vector2i(x1, y)) + ts / 2.0
	var pts := PackedVector2Array([tl, Vector2(br.x, tl.y), br, Vector2(tl.x, br.y)])
	for i in pts.size():
		pts[i] = region.to_local(layer.to_global(pts[i])) # tile -> mundo -> region
	return pts
