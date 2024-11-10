extends Panel

@onready var button1 = $VBoxContainer/GridContainer/VBoxContainer/Machine1
@onready var button2 = $VBoxContainer/GridContainer/VBoxContainer2/Machine2
@onready var button3 = $VBoxContainer/GridContainer/VBoxContainer3/Machine3
@onready var button4 = $VBoxContainer/GridContainer/VBoxContainer4/Machine4

signal add_machine(machine)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	button1.pressed.connect(_arcade_button_pressed.bind(button1))
	button2.pressed.connect(_arcade_button_pressed.bind(button2))
	button3.pressed.connect(_arcade_button_pressed.bind(button3))
	button4.pressed.connect(_arcade_button_pressed.bind(button4))

func _arcade_button_pressed(machine_type):
	add_machine.emit(machine_type.name)
	print("Machine selected: " + machine_type.name)
	hide()
