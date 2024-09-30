extends Control

const SAVE_PATH =  "user://save_time.json"
const SAVE_TIME_PATH =  "user://tmp.dat"
@onready var money_label := $Panel/Panel/MoneyLabel as RichTextLabel
@onready var progress_bar := $Panel/Panel/ProgressBar as ProgressBar
@onready var progress_label := $Panel/Panel/ProgressBar/RichTextLabel as RichTextLabel

var max_offline_minutes: int = 120
var money_history: Array = []
var total_money_in_last_60_seconds: int = 0
var money_generated_this_second: int = 0 
var timer: Timer
var start_time: int
var last_logout_time = 0
var offline_money = 0

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	progress_bar.min_value = 0
	progress_bar.max_value = max_offline_minutes
	offline_money = calculate_offline_income()
	if offline_money:
		money_label.text = "[center][color=#000000]%d[/color][/center]" % offline_money
		visible = true
	
	for i in range(60):
		money_history.append(0)
	timer = Timer.new()
	timer.wait_time = 1.0  # Trigger every second
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_update_money_history"))
	add_child(timer)
	start_time = Time.get_ticks_msec()
	var arcade_machines = get_tree().get_nodes_in_group("arcade")
	for arcade in arcade_machines:
		arcade.connect("money_generated", Callable(self, "add_money"))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_s"):
		save_game()
	if Input.is_action_just_pressed("ui_l"):
		#load_game()
		print(money_history)
	
	
func save_logout_time():
	last_logout_time = Time.get_unix_time_from_system()
	if DirAccess.dir_exists_absolute(SAVE_TIME_PATH):
		print("konz")
		DirAccess.remove_absolute(SAVE_TIME_PATH)

	var file = FileAccess.open(SAVE_TIME_PATH, FileAccess.WRITE)
	file.store_var(last_logout_time)
	file.close()
	
func calculate_offline_income():
	var file = FileAccess.open(SAVE_TIME_PATH, FileAccess.READ)
	if file == null:
		return 0
	last_logout_time = file.get_var()
	file.close()

	var current_time = Time.get_unix_time_from_system()
	var offline_duration = current_time - last_logout_time
	update_offline_time(offline_duration)

	var max_offline_duration = max_offline_minutes * 60
	offline_duration = min(offline_duration, max_offline_duration)

	var money_per_second = 10
	var balancing_factor = 0.2 
	var total_offline_income = money_per_second * offline_duration * balancing_factor

	return total_offline_income

func update_offline_time(offline_seconds: int):
	var offline_minutes = offline_seconds / 60
	
	offline_minutes = clamp(offline_minutes, 0, max_offline_minutes)

	progress_bar.value = offline_minutes
	
	var formatted_time = format_time(offline_seconds)
	progress_label.text = "[center][b][color=#000000]%s[/color][/b][/center]" %(formatted_time + " / 2 hours")

	print("Offline time: ", offline_minutes, " minutes")

func save_game() -> void:
	print("konz")
	save_logout_time()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var elapsed_seconds : int = get_elapsed_time()
	var time_frame = min(elapsed_seconds, 60)
	var money_per_seconds = 0

	for i in range(time_frame):
		money_per_seconds += money_history[60 - time_frame + i]
	
	if time_frame >= 1:
		money_per_seconds /= time_frame
	else:
		money_per_seconds = 0
		
	print(money_per_seconds)
	
	var save_dict := {
		game = {
			mps = var_to_str(money_per_seconds),
		},
		arcades = [],
	}
	file.store_line(JSON.stringify(save_dict))
		
func _update_money_history():
	# Add the money generated this second to the history array
	money_history.append(money_generated_this_second)

	# Remove the oldest value (ensure array always holds 60 elements)
	if money_history.size() > 60:
		money_history.pop_front()

	# Reset the counter for the next second
	money_generated_this_second = 0

	# Calculate the total money generated in the last 60 seconds
	total_money_in_last_60_seconds = 0
	for money in money_history:
		total_money_in_last_60_seconds += money

func add_money(amount: int):
	money_generated_this_second += amount

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
	Globals.money += offline_money
	visible = false
