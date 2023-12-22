extends MarginContainer


@onready var bg = $BG

var planet = null
var grid = null
var type = null
var sector = null
var veins = {}
var areas = {}


func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	grid = input_.grid
	type = input_.type
	sector = input_.sector
	
	init_basic_setting()
	set_neighbor_veins()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.vein
	var style = StyleBoxFlat.new()
	var h = float(sector) / 4
	style.bg_color = Color.from_hsv(h, 0.6, 0.7)#Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func set_neighbor_veins() -> void:
	var n = Global.dict.neighbor.zero.size()
	
	for _i in n:
		var _grid = grid + Global.dict.neighbor.zero[_i]
		
		if planet.check_grid("vein", _grid):
			var vein = planet.get_vein(_grid)
			var index = (_i + 1) % n
			veins[vein] = Global.dict.neighbor.diagonal[index]


func set_neighbor_areas() -> void:
	var n = Global.dict.neighbor.zero.size()
	
	print("___", grid)
	for _i in n:
		var _grid = grid + Global.dict.neighbor.zero[_i]
		
		if planet.check_grid("area", _grid):
			var area = planet.get_area(_grid)
			var index = (_i + 1) % n
			areas[area] = Global.dict.neighbor.diagonal[index]
			print(_grid, Global.dict.neighbor.diagonal[index])
			index = (index + n / 2) % 2
			area.veins[self] = Global.dict.neighbor.diagonal[index]
		
	

