extends Control


func _ready():
	pass

func _on_settings_button_pressed() -> void:
	var settings_scene = preload("res://Scenes/UI/Settings/settings.tscn").instantiate()
	add_child(settings_scene)

func _on_coin_store_button_pressed() -> void:
	var store_scene = preload("res://Scenes/UI/Store/store.tscn").instantiate()
	var scroll_container = store_scene.get_node("ScrollContainer")
	add_child(store_scene)
	scroll_container.scroll_vertical = 0

func _on_gem_store_button_pressed() -> void:
	var store_scene = preload("res://Scenes/UI/Store/store.tscn").instantiate()
	var scroll_container = store_scene.get_node("ScrollContainer")
	add_child(store_scene)
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
