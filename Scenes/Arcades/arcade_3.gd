extends ArcadeMachine
class_name ArcadeMachine3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	machine_name = "Machine Type 3"
	money_per_played = 50
	money_inc = 10
	upgrade_cost = 750
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
