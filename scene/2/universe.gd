extends MarginContainer


@onready var planets = $Planets

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_planets()


func init_planets() -> void:
	for _i in 1:
		var input = {}
		input.universe = self
	
		var planet = Global.scene.planet.instantiate()
		planets.add_child(planet)
		planet.set_attributes(input)
