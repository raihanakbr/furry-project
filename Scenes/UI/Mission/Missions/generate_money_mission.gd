extends Mission

class_name GenerateMoneyMission

var target_money = ScientificNumber.new(0,0) 
var money_generated = ScientificNumber.new(0,0) 
var money_per_second = ScientificNumber.new(0,0) 

func _init(target, money_reward=ScientificNumber.new(0,0), gems_reward=ScientificNumber.new(0,0)):
	rewards.money = money_reward
	rewards.gems = gems_reward
	target_money = target
	target_string = "[center][b]0 / %s[/b][/center]" % target_money
	mission_desc = "Generate %s Money from All Machines" % target
	set_reward_string()

func _ready():
	super()
	var save_load = get_node("/root/Node2D/SaveLoad")
	var arcade_machines = Globals.arcadeGames
	for arcade in arcade_machines:
		var arc = arcade as ArcadeMachine
		arc.connect("money_generated", Callable(self, "generate_money"))

#func connect_signal():
	
	

func generate_money(amount: ScientificNumber):
	money_generated = money_generated.add(amount)
	if money_generated.compare(target_money) >= 1:
		var arcade_machines = Globals.arcadeGames
		for arcade in arcade_machines:
			var arc = arcade as ArcadeMachine
			arc.disconnect("money_generated", Callable(self, "generate_money"))
		money_generated = target_money
		complete()
	else:
		target_text.text = "[center][b]%s / %s[/b][/center]" % [money_generated, target_money]
	
	
