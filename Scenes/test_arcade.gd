extends Node2D

# Preload the npc scene
var npc_scene = preload("res://Scenes/NPCs/npc.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if the spacebar (ui_space action) was just pressed
	if Input.is_action_just_pressed("ui_space"):
		
		# Instance the npc scene
		var npc_instance = npc_scene.instantiate()

		# Set the position of the npc
		npc_instance.position = Vector2(62, 1046)

		# Add the npc instance to the scene as a child
		add_child(npc_instance)
