extends Area2D

var arcade_game = preload("res://Scenes/Arcades/arcade.tscn")

signal arcade_added

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
		if Globals.money.compare(ArcadeMachine.buy_cost):
			Globals.sub_money(ArcadeMachine.buy_cost)
			var new_arcade_game = arcade_game.instantiate()
			new_arcade_game.global_position = global_position
			get_parent().add_child(new_arcade_game)
			arcade_added.emit()
		else:
			print("UANG GACUKUP")
