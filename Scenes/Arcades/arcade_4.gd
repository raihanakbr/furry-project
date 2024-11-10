extends ArcadeMachine
class_name ArcadeMachine4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	machine_name = "Machine Type 4"
	money_per_played = ScientificNumber.new(1,2)
	money_inc = ScientificNumber.new(2,1)
	upgrade_cost = ScientificNumber.new(1.5,3)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
