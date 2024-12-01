extends Mission

class_name PlayTimeMission

var target_duration = 0
var duration_played = 0
var playtime_controller

func _init(target, money_reward=ScientificNumber.new(0,0), gems_reward=ScientificNumber.new(0,0), duration_played = 0):
	rewards.money = money_reward
	rewards.gems = gems_reward
	target_duration = target
	self.duration_played = duration_played
	target_string = "[center][b]%s / %s[/b][/center]" % [format_time(duration_played), format_time(target_duration)]
	mission_desc = "Play for %s" % format_time(target)
	set_reward_string()

func _ready():
	super()
	playtime_controller = get_node("/root/Node2D/PlaytimeMissionController")
	playtime_controller.connect("one_sec_elapsed", Callable(self, "one_sec_elapsed"))

func update_target():
	one_sec_elapsed()

func one_sec_elapsed():
	duration_played += 1
	if	duration_played >= target_duration:
		playtime_controller.disconnect("money_generated", Callable(self, "generate_money"))
		duration_played = target_duration
		complete()
	else:
		target_text.text = "[center][b]%s / %s[/b][/center]" % [format_time(duration_played), format_time(target_duration)]
	
func format_time(seconds: int) -> String:
	if seconds < 60:
		return "%d second" % seconds
	var minutes = seconds / 60
	var hours = minutes / 60
	var remaining_minutes = minutes % 60

	var formatted_time = ""

	if hours > 0:
		formatted_time += str(hours) + " hour" + ("s" if hours != 1 else "")

	if hours > 0 and remaining_minutes > 0:
		formatted_time += " and "

	if remaining_minutes > 0:
		formatted_time += str(remaining_minutes) + " minute" + ("s" if remaining_minutes != 1 else "")
	return formatted_time
