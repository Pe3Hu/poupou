extends MarginContainer


@onready var areas = $Areas
@onready var veins = $Veins

var universe = null


func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	init_areas()
	init_veins()
	
	var vein = veins.get_child(11)
	
	for area in vein.areas:
		area.set_terrain("pond")


func init_areas() -> void:
	var corners = {}
	corners.x = [0, Global.num.vein.col - 1]
	corners.y = [0, Global.num.vein.row - 1]
	
	areas.columns = Global.num.area.col
	
	for _i in Global.num.area.row:
		for _j in Global.num.area.col:
			var input = {}
			input.planet = self
			input.grid = Vector2(_j, _i)
			
			if corners.y.has(_i) or corners.x.has(_j):
				if corners.y.has(_i) and corners.x.has(_j):
					input.type = "corner"
				else:
					input.type = "edge"
			else:
				input.type = "center"
	
			var area = Global.scene.area.instantiate()
			areas.add_child(area)
			area.set_attributes(input)


func init_veins() -> void:
	veins.columns = Global.num.vein.col
	veins.set("theme_override_constants/h_separation", Global.vec.size.gap.x)
	veins.set("theme_override_constants/v_separation", Global.vec.size.gap.y)
	
	var corners = {}
	corners.x = [0, Global.num.vein.col - 1]
	corners.y = [0, Global.num.vein.row - 1]
	
	for _i in Global.num.vein.row:
		for _j in Global.num.vein.col:
			var input = {}
			input.planet = self
			input.grid = Vector2(_j, _i)
			var x = sign(_j - Global.num.vein.col / 2 + 0.5) + 1
			var y = sign(_i - Global.num.vein.row / 2 + 0.5) + 1
			input.sector = x / 2 + y
			
			if corners.y.has(_i) or corners.x.has(_j):
				if corners.y.has(_i) and corners.x.has(_j):
					input.type = "corner"
				else:
					input.type = "edge"
			else:
				input.type = "center"
			
			var vein = Global.scene.vein.instantiate()
			veins.add_child(vein)
			vein.set_attributes(input)


func check_grid(type_: String, grid_: Vector2) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and Global.num[type_].row >  grid_.y and Global.num[type_].col >  grid_.x


func get_area(grid_: Vector2) -> Variant:
	if check_grid("area", grid_):
		var index = grid_.y * Global.num.area.col + grid_.x
		return areas.get_child(index)
	
	return null


func get_vein(grid_: Vector2) -> Variant:
	if check_grid("vein", grid_):
		var index = grid_.y * Global.num.vein.col + grid_.x
		return veins.get_child(index)
	
	return null
