extends Control

@onready var coin_text := $PanelCoin/VBoxContainer/RichTextLabel as RichTextLabel
@onready var gems_text := $PanelGems/VBoxContainer/RichTextLabel as RichTextLabel

func _ready():
	pass


func _process(delta):
	coin_text.text = "[center][b]%s[/b][/center]" %Globals.money
	gems_text.text = "[center][b]%s[/b][/center]" %Globals.gems

func _on_settings_button_pressed() -> void:
	var settings_scene = $Settings
	settings_scene.visible = true
	settings_scene.z_index = 6969

func _on_coin_store_button_pressed() -> void:
	var store_scene = $Store
	store_scene.visible = true
	store_scene.z_index = 6969
	var scroll_container = store_scene.get_node("ScrollContainer")
	scroll_container.scroll_vertical = 0



func _on_gem_store_button_pressed() -> void:
	var store_scene = $Store
	store_scene.visible = true
	var scroll_container = store_scene.get_node("ScrollContainer")
	store_scene.z_index = 6969
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


func _on_mission_button_pressed() -> void:
	var mission_scene = $Mission
	mission_scene.visible = true
	mission_scene.z_index = 101
