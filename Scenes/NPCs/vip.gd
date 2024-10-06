extends npc

var id = 0

func _ready() -> void:
	super()
	Globals.affections[id] += 1
