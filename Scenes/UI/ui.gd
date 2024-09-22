extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_button_pressed() -> void:
	var settings_scene = preload("res://Scenes/UI/Settings/settings.tscn")
	var instance = settings_scene.instantiate()
	add_child(instance)
	
