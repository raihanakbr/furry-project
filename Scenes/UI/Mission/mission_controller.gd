extends Control

@onready var mission_panel_list = [$Panel/VBoxContainer/MarginContainer2/Panel, $Panel/VBoxContainer/MarginContainer3/Panel, $Panel/VBoxContainer/MarginContainer4/Panel]

var money_per_second: ScientificNumber
var offline_income: OfflineIncome
var timer: Timer
func _ready() -> void:
	offline_income =  get_node("/root/Node2D/CanvasLayer/OfflineIncome")
	var save_load = get_node("/root/Node2D/SaveLoad")
	save_load.connect("game_loaded", Callable(self, "_on_game_loaded"))
	#money_per_second = offline_income.calculate_money_per_second()
	
	for mission in Globals.mission_list:
		if mission:
			mission.connect("mission_completed", Callable(self, "_on_mission_completed"))

func _process(delta: float) -> void:
	pass
	
func _on_mission_completed(mission : Mission):
	for i in range(3):
		var mission_match = Globals.mission_list[i]
		if mission == mission_match:
			for child in mission_panel_list[i].get_children():
				child.visible = false
			mission.queue_free()
			timer = Timer.new()
			timer.wait_time = 0.5
			timer.one_shot = true
			add_child(timer)
			timer.connect("timeout", Callable(self, "_generate_new_mission").bind(i))
			timer.start()
			for panel:Panel in mission_panel_list:
				for child in panel.get_children():
					if child is Button:
						child.disabled = true
			break

func _generate_new_mission(i):
	for child in mission_panel_list[i].get_children():
		child.visible = true
	if timer:
		timer.queue_free()
	money_per_second = offline_income.calculate_money_per_second()

	var mission = _get_random_mission(i)
	
	add_child(mission)
	Globals.mission_list[i] = mission
	var panel = mission_panel_list[i] as Panel
	var label = panel.get_node("VBoxContainer/RichTextLabel") as RichTextLabel
	var reward_label = panel.get_node("Panel/VBoxContainer/RichTextLabel") as RichTextLabel
	mission.claim_button = panel.get_node("Button")
	mission.target_text = panel.get_node("Button/VBoxContainer/RichTextLabel")
	mission.target_text.text = mission.target_string
	mission.reward_text = reward_label
	mission.reward_text.text = mission.reward_string
	mission.update_target()
	mission.connect("mission_completed", Callable(self, "_on_mission_completed"))
	label.text = "[center]%s[/center]" % mission.mission_desc 
	mission.claim_button.disabled = true
	for missions in Globals.mission_list:
		if missions:
			missions.update_status()

func _get_random_mission(i):
	if Globals.mission_list[i] and is_instance_valid(Globals.mission_list[i]):
		if Globals.mission_list[i] is GenerateMoneyMission :
			pass
			#print(Globals.mission_list[i].rewards)
			#print(Globals.mission_list[i].money_generated)
			#print(Globals.mission_list[i].target_money)
		return Globals.mission_list[i]
		
	var get_gems = false
	var gems_reward = ScientificNumber.new(0,0)
	if randf() <= 0.1:
		gems_reward = ScientificNumber.new(randi_range(1,3),0)
		get_gems = true
	if randf() < 0.5:
		var random_secs = randi_range(10,300)
		var base_min = ScientificNumber.new(5,0)
		if money_per_second.compare(base_min) < 1:
			money_per_second = base_min
		var target = money_per_second.mult(random_secs)
		if get_gems:
			return GenerateMoneyMission.new(target, ScientificNumber.ZERO, gems_reward)
		else:
			return GenerateMoneyMission.new(target, target.div(5))
	else:
		var rand = randi_range(2, 10) * 60
		var base_min = ScientificNumber.new(5,0)
		if money_per_second.compare(base_min) < 1:
			money_per_second = base_min
		var reward = money_per_second.mult(rand).div(5)
		if get_gems:
			return PlayTimeMission.new(rand,ScientificNumber.ZERO,gems_reward)
		else:
			return PlayTimeMission.new(rand,reward)

func _on_game_loaded() -> void:
	
	for i in range(3):
		_generate_new_mission(i)
		
	

func _on_close_button_pressed() -> void:
	visible = false
