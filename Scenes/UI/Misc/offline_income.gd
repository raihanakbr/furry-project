extends Control
class_name OfflineIncome
const SAVE_PATH =  "user://save_mps.json"
const SAVE_TIME_PATH =  "user://save_time.dat"
@onready var money_label := $Panel/Panel/MoneyLabel as RichTextLabel
@onready var progress_bar := $Panel/Panel/ProgressBar as ProgressBar
@onready var progress_label := $Panel/Panel/ProgressBar/RichTextLabel as RichTextLabel
@onready var http_request_manager = preload("res://Scenes/http_request_manager.gd").new()
var max_offline_minutes: int = 300
var money_history: Array = []
var total_money_in_last_60_seconds = ScientificNumber.new(0,0)
var money_generated_this_second = ScientificNumber.new(0,0)
var timer: Timer
var start_time: int
var last_logout_time = 0
var offline_money = ScientificNumber.new(0,0)
var start_unix_time
var can_save = true
var save_load
var is_loaded

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	add_child(http_request_manager)
	$Panel2.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	http_request_manager.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	get_tree().paused = true
	http_request_manager.connect("request_completed", Callable(self, "_on_request_completed"))
	http_request_manager.connect("request_timeout", Callable(self, "_on_request_timeout"))
	http_request_manager.send_request("http://worldtimeapi.org/api/timezone/Asia/Jakarta")
	
	var save_load = get_node("/root/Node2D/SaveLoad")
	save_load.connect("game_loaded", Callable(self, "_set_is_loaded"))

func _set_is_loaded():
	is_loaded = true
	print(is_loaded, start_unix_time)
	if start_unix_time:
		is_loaded = false
		_on_game_loaded()

func _on_request_timeout():
	print("to")
	
	$Panel2.visible = true
	$Panel2/Panel/TryAgainButton.disabled = false
	
func _on_request_completed(result, response_code, headers, body):
	print("gg")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	if response_code == 200:
		if response['unixtime']:
			start_unix_time = response['unixtime']
			print(start_unix_time, is_loaded)
			if is_loaded:
				is_loaded = false
				_on_game_loaded()

func _on_game_loaded() -> void:
	get_tree().paused = false
	progress_bar.min_value = 0
	progress_bar.max_value = max_offline_minutes
	
	offline_money = calculate_offline_income()
	if offline_money.mantissa != 0:
		money_label.text = "[center][color=#000000]%s[/color][/center]" % offline_money
		$Panel.visible = true
		$Panel2.visible = false
	
	for i in range(60):
		money_history.append(ScientificNumber.new(0,0))
	timer = Timer.new()
	timer.wait_time = 1.0  # Trigger every second
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_update_money_history"))
	add_child(timer)
	start_time = Time.get_ticks_msec()
	var arcade_machines = Globals.arcadeGames
	for arcade in arcade_machines:
		arcade.connect("money_generated", Callable(self, "add_money"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_s"):
		save_game()
	if Input.is_action_just_pressed("ui_l"):
		pass
		#load_game()
	
	
func save_logout_time(logout_time):
	if DirAccess.dir_exists_absolute(SAVE_TIME_PATH):
		DirAccess.remove_absolute(SAVE_TIME_PATH)

	var file = FileAccess.open(SAVE_TIME_PATH, FileAccess.WRITE)
	file.store_var(logout_time)
	file.close()

func calculate_offline_income() -> ScientificNumber:
	var file = FileAccess.open(SAVE_TIME_PATH, FileAccess.READ)
	
	if file == null:
		return ScientificNumber.new(0,0)
	
	
	last_logout_time = file.get_var()
	file.close()
	
	
	
	var current_time = start_unix_time
	var offline_duration = current_time - last_logout_time
	var money_per_second = calculate_money_per_second()
	
	var max_offline_duration = max_offline_minutes * 60
	offline_duration = min(offline_duration, max_offline_duration)
	update_offline_time(offline_duration)
	var balancing_factor = 0.3
	var total_offline_income = money_per_second.mult(offline_duration*balancing_factor)
	
	return total_offline_income

func update_offline_time(offline_seconds: int):
	var offline_minutes = offline_seconds / 60
	
	offline_minutes = clamp(offline_minutes, 0, max_offline_minutes)

	progress_bar.value = offline_minutes
	
	var formatted_time = format_time(offline_seconds)
	var max_offline = format_time(max_offline_minutes * 60)
	progress_label.text = "[center][b][color=#000000]%s / %s[/color][/b][/center]" % [formatted_time, max_offline]

func save_game() -> void:
	if $Panel.visible:
		Globals.add_money(offline_money)
	
	var logout_unix_time = start_unix_time + get_elapsed_time()
	save_logout_time(logout_unix_time)
	
	var money_per_seconds = calculate_money_per_second()
	if money_per_seconds.mantissa == 0:
		return
	var save_dict := {
		mps_mant = var_to_str(money_per_seconds.mantissa),
		mps_exp = var_to_str(money_per_seconds.exponent),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_dict))
		
func calculate_money_per_second() -> ScientificNumber:
	var money_per_seconds = ScientificNumber.new(0,0)
	var elapsed_seconds : int = get_elapsed_time()
	var time_frame = min(elapsed_seconds, 60)
	
	if money_history:
		for i in range(time_frame):
			money_per_seconds = money_per_seconds.add(money_history[60 - time_frame + i])
	if time_frame >= 1:
		money_per_seconds = money_per_seconds.div(time_frame)	
		
	else:
		money_per_seconds = ScientificNumber.new(0,0)
		
		
	
	var money_per_seconds_saved = ScientificNumber.new(0,0)
	var file_mps = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file_mps != null:
		var json := JSON.new()
		json.parse(file_mps.get_line())
		if !json.get_data():
			return ScientificNumber.new(0,0)
		var save_dict := json.get_data() as Dictionary
		money_per_seconds_saved.mantissa = str_to_var(save_dict.mps_mant)
		money_per_seconds_saved.exponent = str_to_var(save_dict.mps_exp)
		
		file_mps.close()
	var mps
	if money_per_seconds.compare(money_per_seconds_saved) == 0:
		mps = money_per_seconds_saved
	else:
		mps = money_per_seconds
	return mps	
	
func _update_money_history():
	money_history.append(money_generated_this_second)

	if money_history.size() > 60:
		money_history.pop_front()

	money_generated_this_second = ScientificNumber.new(0,0)

	total_money_in_last_60_seconds = ScientificNumber.new(0,0)
	for money in money_history:
		total_money_in_last_60_seconds = total_money_in_last_60_seconds.add(money)

func add_money(amount: ScientificNumber):
	money_generated_this_second =  money_generated_this_second.add(amount)

func get_elapsed_time():
	var current_time = Time.get_ticks_msec()  
	var elapsed_time = current_time - start_time
	var seconds = elapsed_time / 1000
	return seconds

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

func _on_claim_button_pressed() -> void:
	Globals.add_money(offline_money)
	$Panel.visible = false


func _on_try_again_button_pressed() -> void:
	$Panel2/Panel/TryAgainButton.disabled = true
	http_request_manager.send_request("http://worldtimeapi.org/api/timezone/Asia/Jakarta")
