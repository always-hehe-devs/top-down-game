extends TileMap

var texture = load("res://2d_lights_and_shadows_neutral_point_light.webp")

func _ready():
	for cell in get_used_cells(0):
		var cell_data = get_cell_tile_data(0, cell)
		if cell_data.get_custom_data("light_source"):
			var point_light := PointLight2D.new()
			point_light.texture = texture
			point_light.scale = Vector2(0.45,0.45)
			point_light.position = map_to_local(cell)
			point_light.color.a = 0.5
			add_child(point_light)
