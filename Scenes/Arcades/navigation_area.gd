extends NavigationRegion2D

var arcade_area_scene = preload("res://Scenes/Arcades/arcade_area.tscn")
var arcade_game_1 = preload("res://Scenes/Arcades/arcade.tscn")
var arcade_game_2 = preload("res://Scenes/Arcades/arcade_2.tscn")
var arcade_game_3 = preload("res://Scenes/Arcades/arcade_3.tscn")
var arcade_game_4 = preload("res://Scenes/Arcades/arcade_4.tscn")
var _tmp_arcade_aera : Array[Node2D] = []
var _arcade_area_positions: Array[Vector2] = []
var _presssed_pos

@onready var _add_button = $"../CanvasLayer/Button"
@onready var _arcade_choice = $"../CanvasLayer/Panel"

func _ready():
	# Create a new NavigationPolygon
	var nav_polygon = NavigationPolygon.new()
	
	# Define the outer points for the polygon (navigable area)
	var outer_points = [
		Vector2(-2000, -2000),
		Vector2(2000, -2000),
		Vector2(2000, 2000),
		Vector2(-2000, 2000)
	]
	
	# Add the outer points as the main outline
	var outer_outline = PackedVector2Array(outer_points)
	nav_polygon.add_outline(outer_outline)
	
	# Define points for the first hole (non-navigable area)
	var hole1_points = [
		Vector2(100, 100),
		Vector2(200, 100),
		Vector2(200, 200),
		Vector2(100, 200)
	]
	_arcade_area_positions.append(get_midpoint(hole1_points))
	
	# Add the first hole
	var hole1_outline = PackedVector2Array(hole1_points)
	nav_polygon.add_outline(hole1_outline)
	
	# Define points for the second hole
	var hole2_points = [
		Vector2(300, 300),
		Vector2(400, 300),
		Vector2(400, 400),
		Vector2(300, 400)
	]
	
	
	_arcade_area_positions.append(get_midpoint(hole2_points))
	
	# Add the second hole
	var hole2_outline = PackedVector2Array(hole2_points)
	nav_polygon.add_outline(hole2_outline)
	
	# Build the navigation polygon with holes
	nav_polygon.make_polygons_from_outlines()
	
	# Assign the NavigationPolygon to the NavigationRegion2D
	self.navigation_polygon = nav_polygon

	# Trigger the custom draw function for debugging
	#queue_redraw()


# Debug draw to visualize polygons
func _draw():
	var outer_color = Color(0, 1, 0, 0.3)  # Green, semi-transparent
	var hole_color = Color(1, 0, 0, 0.3)   # Red, semi-transparent
	
	# Create PackedColorArrays for the polygons
	var outer_color_array = PackedColorArray([outer_color, outer_color, outer_color, outer_color])  # Four vertices, same color
	var hole_color_array = PackedColorArray([hole_color, hole_color, hole_color, hole_color])    # Four vertices, same color
	
	# Draw the outer polygon with a PackedColorArray
	draw_polygon(navigation_polygon.get_outline(0), outer_color_array)
	
	# Draw the holes (internal polygons) with a PackedColorArray
	for i in range(1, navigation_polygon.get_outline_count()):
		draw_polygon(navigation_polygon.get_outline(i), hole_color_array)
	pass
		
func get_midpoint(points: PackedVector2Array):
	var _x = ((points[0].x + points[1].x) / 2)
	var _y = ((points[1].y + points[2].y) / 2)
	print(_x)
	print(_y)
	return Vector2(_x + 32, _y - 8)

func _process(_delta: float) -> void:
	pass

func _clear_arcade_areas():
	print("cleared")
	for obj in _tmp_arcade_aera:
		if is_instance_valid(obj):
			obj.queue_free()
	_tmp_arcade_aera = []
	_add_button.text = "+"

func _on_button_pressed() -> void:
	if len(_tmp_arcade_aera) > 0:
		_clear_arcade_areas()
	else:
		for area_pos in _arcade_area_positions:
			var new_area = arcade_area_scene.instantiate()
			new_area.position = area_pos
			new_area.area_pressed.connect(_area_pressed)
			get_parent().add_child(new_area)
			get_parent().move_child(new_area, get_parent().get_child_count() - 1)
			_tmp_arcade_aera.append(new_area)
		_add_button.text = "-"

func _area_pressed(pos) -> void:
	_arcade_choice.show()
	_presssed_pos = pos

func _on_panel_add_machine(machine) -> void:
	if machine == "Machine1":
		if Globals.money.compare(ArcadeMachine.buy_cost):
			Globals.sub_money(ArcadeMachine.buy_cost)
			var new_arcade_game = arcade_game_1.instantiate()
			new_arcade_game.global_position = _presssed_pos
			get_parent().add_child(new_arcade_game)
	elif machine == "Machine2":
		if Globals.money.compare(ArcadeMachine2.buy_cost):
			Globals.sub_money(ArcadeMachine2.buy_cost)
			var new_arcade_game = arcade_game_2.instantiate()
			new_arcade_game.global_position = _presssed_pos
			get_parent().add_child(new_arcade_game)
	elif machine == "Machine3":
		if Globals.money.compare(ArcadeMachine3.buy_cost):
			Globals.sub_money(ArcadeMachine3.buy_cost)
			var new_arcade_game = arcade_game_3.instantiate()
			new_arcade_game.global_position = _presssed_pos
			get_parent().add_child(new_arcade_game)
	elif machine == "Machine4":
		if Globals.money.compare(ArcadeMachine4.buy_cost):
			Globals.sub_money(ArcadeMachine4.buy_cost)
			var new_arcade_game = arcade_game_4.instantiate()
			new_arcade_game.global_position = _presssed_pos
			get_parent().add_child(new_arcade_game)
