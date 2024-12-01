extends Node2D

signal one_sec_elapsed

func _ready() -> void:
	one_sec_timer()

func one_sec_timer() -> void:
	while true:
		await get_tree().create_timer(1.0).timeout
		emit_signal("one_sec_elapsed")
