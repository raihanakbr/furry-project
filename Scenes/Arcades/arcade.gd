extends Node2D

var isOccupied: bool = false

func _ready() -> void:
	Globals.arcadeGames.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
