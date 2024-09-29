extends CharacterBody2D

const speed = 200

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var play_time := $Timer as Timer

var idx = -1
var hasPlayed: bool = false

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	makepath()

func _physics_process(_delta: float) -> void:
	if Globals.arcadeGames == null:
		return
		
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	print(to_local(nav_agent.get_next_path_position()))
	velocity = dir * speed
	move_and_slide()
	
func makepath() -> void:
	idx = -1
	for i in range(len(Globals.arcadeGames)):
		if Globals.arcadeGames[i].isOccupied == false:
			idx = i
			Globals.arcadeGames[idx].isOccupied = true
			break
		
	if idx == -1:
		queue_free()
		return
		
	nav_agent.target_position = Globals.arcadeGames[idx].global_position + Vector2(0, 50)
	
func _on_navigation_agent_2d_target_reached() -> void:
	play_time.start()
	if hasPlayed:
		queue_free()
	
func _on_timer_timeout() -> void:
	hasPlayed = true
	Globals.arcadeGames[idx].isOccupied = false
	nav_agent.target_position = Vector2(212, 1223)
