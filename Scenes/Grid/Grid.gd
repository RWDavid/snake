extends TileMap

signal moved_into_death
signal moved_onto_food(food_entity, entity)

onready var half_cell_size = get_cell_size() / 2

var grid_size = Vector2(32, 24)
var grid = []

func _ready():
	setup_grid()

func setup_grid():
	grid = []
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

func get_entity_of_cell(grid_pos: Vector2) -> Node2D:
	return grid[grid_pos.x][grid_pos.y] as Node2D

func set_entity_of_cell(entity: Node2D, grid_pos: Vector2):
	grid[grid_pos.x][grid_pos.y] = entity

func place_entity(entity: Node2D, grid_pos: Vector2):
	set_entity_of_cell(entity, grid_pos)
	entity.set_position(map_to_world(grid_pos) + half_cell_size)

func place_entity_at_random_pos(entity: Node2D):
	var random_pos: Vector2
	var has_random_pos = false
	while not has_random_pos:
		random_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		if not get_entity_of_cell(random_pos):
			has_random_pos = true
	place_entity(entity, random_pos)

func move_entity_in_direction(entity: Node2D, direction: Vector2):
	var old_grid_pos = world_to_map(entity.position)
	var new_grid_pos = old_grid_pos + direction
	if not is_cell_inside_bounds(new_grid_pos):
		entity.dead = true
		setup_grid()
		emit_signal("moved_into_death")
		return
	
	var entity_of_new_cell: Node2D = get_entity_of_cell(new_grid_pos)
	if entity_of_new_cell != null:
		if entity_of_new_cell.is_in_group("Player"):
			entity.dead = true
			setup_grid()
			emit_signal("moved_into_death")
			return
		elif entity_of_new_cell.is_in_group("Food"):
			emit_signal("moved_onto_food", entity_of_new_cell, entity)
	
	set_entity_of_cell(null, old_grid_pos)
	place_entity(entity, new_grid_pos)

func is_cell_inside_bounds(pos: Vector2):
	return pos.x >= 0 and pos.x < grid_size.x \
		and pos.y >= 0 and pos.y < grid_size.y
