extends TileMapLayer

const WORLD_COLLISION_LAYER := 1


func _ready() -> void:
	var static_body := StaticBody2D.new()
	static_body.name = "WallsCollision"
	static_body.collision_layer = WORLD_COLLISION_LAYER
	static_body.collision_mask = 0
	add_child(static_body)

	var cells_by_row: Dictionary = {}
	for cell: Vector2i in get_used_cells():
		if not cells_by_row.has(cell.y):
			cells_by_row[cell.y] = []
		cells_by_row[cell.y].append(cell.x)

	var tile_size := tile_set.tile_size
	for row_key in cells_by_row:
		var row: int = row_key
		var columns: Array = cells_by_row[row]
		columns.sort()
		var run_start: int = columns[0]
		var previous_column: int = columns[0]

		for index in range(1, columns.size()):
			var column: int = columns[index]
			if column != previous_column + 1:
				_add_collision_run(static_body, row, run_start, previous_column, tile_size)
				run_start = column
			previous_column = column

		_add_collision_run(static_body, row, run_start, previous_column, tile_size)


func _add_collision_run(
	static_body: StaticBody2D,
	row: int,
	start_column: int,
	end_column: int,
	tile_size: Vector2i
) -> void:
	var first_cell := Vector2i(start_column, row)
	var last_cell := Vector2i(end_column, row)
	var shape := RectangleShape2D.new()
	shape.size = Vector2(tile_size.x * (end_column - start_column + 1), tile_size.y)

	var collision_shape := CollisionShape2D.new()
	collision_shape.position = (map_to_local(first_cell) + map_to_local(last_cell)) / 2.0
	collision_shape.shape = shape
	static_body.add_child(collision_shape)
