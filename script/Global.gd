extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.spot = ["corner", "edge", "center"]


func init_num() -> void:
	num.index = {}
	
	num.area = {}
	num.area.col = 5
	num.area.row = num.area.col
	
	num.vein = {}
	num.vein.row = num.area.row + 1
	num.vein.col = num.area.col + 1


func init_dict() -> void:
	init_neighbor()
	init_element()
	init_area()
	init_weather()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_element() -> void:
	dict.element = {}
	dict.element.terrain = {}
	color.terrain = {}
	
	var path = "res://asset/json/poupou_element.json"
	var array = load_data(path)
	
	for element in array:
		dict.element.terrain[element.title] = element.terrain
		var h = element.hue / 360.0
		color.terrain[element.terrain] = Color.from_hsv(h, 0.6, 0.7)


func init_area() -> void:
	dict.area = {}
	dict.area.title = {}
	
	var path = "res://asset/json/poupou_area.json"
	var array = load_data(path)
	
	for area in array:
		var data = {}
		data.spots = []
		
		for key in area:
			if key != "title":
				if arr.spot.has(key):
					data.spots.append(key)
				else:
					data[key] = area[key]
		
		dict.area.title[area.title] = data


func init_weather() -> void:
	dict.weather = {}
	dict.weather.title = {}
	
	var path = "res://asset/json/poupou_weather.json"
	var array = load_data(path)
	
	for weather in array:
		var data = {}
		data.terrains = []
		
		for key in weather:
			if key != "title":
				var words = key.split(" ")
				
				if words.has("terrain"):
					data.terrains.append(weather[key])
					#data.terrains[words[1]] = weather[key]
				else:
					data[key] = weather[key]
		
		dict.weather.title[weather.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	scene.vein = load("res://scene/2/vein.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(120, 12)
	
	vec.size.area = Vector2(96, 96)
	vec.size.vein = Vector2(48, 48)
	vec.size.gap = vec.size.area - vec.size.vein
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.defender = {}
	color.defender.active = Color.from_hsv(120 / h, 0.6, 0.7)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
