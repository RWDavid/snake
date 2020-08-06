extends Node2D

onready var grid = get_parent()

export var line_color = Color()
export var line_thickness = 1

func _draw():
	for x in range(grid.grid_size.x + 1):
		var start_point = Vector2(x * grid.cell_size.x, 0)
		var end_point = Vector2(x * grid.cell_size.x, grid.grid_size.y * grid.cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)
	
	for y in range(grid.grid_size.y + 1):
		var start_point = Vector2(0, y * grid.cell_size.y)
		var end_point = Vector2(grid.grid_size.x * grid.cell_size.x, y * grid.cell_size.y)
		draw_line(start_point, end_point, line_color, line_thickness)
		
#	for x in range(grid.grid_size.x):
#		for y in range(grid.grid_size.y):
#			if grid.grid[x][y]:
#				var start = Vector2(x * grid.cell_size.x, y * grid.cell_size.y)
#				var end = Vector2((x + 1) * grid.cell_size.x, (y + 1) * grid.cell_size.y)
#				draw_line(start, end, Color.white, 3.0)
				
func _process(delta):
	update()
