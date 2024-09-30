extends ArcadeMachine
class_name ArcadeMachine4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	machine_name = "Machine Type 4"
	money_per_played = 100
	money_inc = 20
	upgrade_cost = 1500
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
