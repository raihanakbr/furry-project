extends ArcadeMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	machine_name = "Machine Type 2"
	money_per_played = 15
	money_inc = 5
	upgrade_cost = 200
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
