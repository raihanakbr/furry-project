extends Node2D

# Preload the npc scene
var npc_scene = preload("res://Scenes/NPCs/npc.tscn")
var vip_scene = preload("res://Scenes/NPCs/vip.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rand_int = rng.randi_range(1, 100)
	
	var npc_instance
	
	if rand_int == 69:
		npc_instance = npc_scene.instantiate()
	else:
		npc_instance = vip_scene.instantiate()
	
	# Set the position of the npc
	npc_instance.position = Vector2(62, 1046)

	# Add the npc instance to the scene as a child
	add_child(npc_instance)
