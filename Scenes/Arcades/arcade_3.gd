extends ArcadeMachine
class_name ArcadeMachine3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	machine_name = "Machine Type 3"
	money_per_played = ScientificNumber.new(5,1)
	money_inc = ScientificNumber.new(1,1)
	upgrade_cost = ScientificNumber.new(7.5,2)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
