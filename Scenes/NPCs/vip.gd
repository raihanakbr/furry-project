extends npc

var id = 0

func _ready() -> void:
	await super()
	Globals.affections[id] += 1
	if target != null:
		await get_tree().create_timer(3.0).timeout
		$"../Camera2D/AnimationPlayer".play("judy_hopps")
