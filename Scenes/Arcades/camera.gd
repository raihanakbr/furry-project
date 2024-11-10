extends Camera2D

@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0

@export var can_zoom: bool
@export var can_pan: bool

var touch_points: Dictionary = {}
var start_distance
var start_zoom
var start_angle
var current_angle

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		
		start_zoom = zoom
	elif touch_points.size() < 2:
		start_distance = 0
		
func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	
	if touch_points.size() == 1:
		if can_pan:
			position -= event.relative * pan_speed / zoom.x
			position.x = clamp(position.x, -1000, 1000)
			position.y = clamp(position.y, -1000, 1000)
	
	if touch_points.size() == 2:
		var touch_points_positions = touch_points.values()
		var current_distance = touch_points_positions[0].distance_to(touch_points_positions[1])
		
		var zoom_factor = start_distance / current_distance
		if can_zoom:
			zoom = start_zoom / zoom_factor
		limit_zoom(zoom)

func limit_zoom(new_zoom):
	if new_zoom.x < 0.4:
		zoom.x = 0.4
	if new_zoom.y < 0.4:
		zoom.y = 0.4
	if new_zoom.x > 10:
		zoom.x = 10
	if new_zoom.y > 10:
		zoom.y = 10
