extends Node2D

@export var game_node: NodePath
const SAVE_PATH =  "user://savegame.json"

signal game_loaded


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	load_game()
	
func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	var save_dict := {
		game = {
			money = var_to_str(Globals.money),
			gems = var_to_str(Globals.gems),
		},
		arcades = [],
	}
	for game in Globals.arcadeGames:
		var arcade_game = game as ArcadeMachine
		var arcade_class = "Unknown"
		if arcade_game is ArcadeMachine2:
			arcade_class = "ArcadeMachine2"
		elif arcade_game is ArcadeMachine3:
			arcade_class = "ArcadeMachine3"
		elif arcade_game is ArcadeMachine4:
			arcade_class = "ArcadeMachine4"
		else:
			arcade_class = "ArcadeMachine"
		save_dict.arcades.push_back({
			position = var_to_str(arcade_game.position),
			money_per_played = var_to_str(arcade_game.money_per_played),
			level = var_to_str(arcade_game.level),
			upgrade_cost = var_to_str(arcade_game.upgrade_cost),
			money_inc = var_to_str(arcade_game.money_inc), 
			arcade_type = arcade_class,
		}) 
	file.store_line(JSON.stringify(save_dict))

func load_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict := json.get_data() as Dictionary

	# JSON doesn't support many of Godot's types such as Vector2.
	# str_to_var can be used to convert a String to the corresponding Variant.
	Globals.money = str_to_var(save_dict.game.money)
	Globals.gems = str_to_var(save_dict.game.gems)
	
	Globals.arcadeGames.clear()
	get_tree().call_group("arcade", "queue_free")
	get_tree().call_group("npc", "queue_free")
	# Ensure the node structure is the same when loading.
	var game := get_node(game_node)
	for arcade_config: Dictionary in save_dict.arcades:
		var arcade_type = arcade_config.arcade_type
		var arcade_scene = null

		match arcade_type:
			"ArcadeMachine2":
				arcade_scene = preload("res://Scenes/Arcades/arcade_2.tscn")
			"ArcadeMachine3":
				arcade_scene = preload("res://Scenes/Arcades/arcade_3.tscn")
			"ArcadeMachine4":
				arcade_scene = preload("res://Scenes/Arcades/arcade_4.tscn")
			_:
				arcade_scene = preload("res://Scenes/Arcades/arcade.tscn")
				
		var arcade_instance = arcade_scene.instantiate() as ArcadeMachine
		game.add_child(arcade_instance) 

		arcade_instance.position = str_to_var(arcade_config.position)
		arcade_instance.money_per_played = str_to_var(arcade_config.money_per_played)
		arcade_instance.level = str_to_var(arcade_config.level)
		arcade_instance.upgrade_cost = str_to_var(arcade_config.upgrade_cost)
		arcade_instance.money_inc = str_to_var(arcade_config.money_inc)
	emit_signal("game_loaded")
	
