extends Area2D

var arcade_game = preload("res://Scenes/Arcades/arcade.tscn")

signal area_pressed(pos)

var increasing = true
var speed = 200.0

func _process(delta: float) -> void:
	# Get the current alpha (visibility) value
	var current_alpha = modulate.a * 255.0
	
	if increasing:
		current_alpha += speed * delta
		if current_alpha >= 255.0:
			current_alpha = 255.0
			increasing = false
	else:
		current_alpha -= speed * delta
		if current_alpha <= 100.0:
			current_alpha = 100.0
			increasing = true
			
	modulate.a = current_alpha / 255.0

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch:
		area_pressed.emit(global_position)
