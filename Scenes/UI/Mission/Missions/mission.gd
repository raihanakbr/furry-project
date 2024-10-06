extends Node2D
class_name Mission
signal mission_completed(mission: Mission)
var rewards = {
	"gems" : ScientificNumber.new(0,0),
	"money" : ScientificNumber.new(0,0),
}

var mission_name: String
var is_completed = false
var mission_desc: String
var target_text: RichTextLabel
var reward_text: RichTextLabel
var claim_button: Button
var target_string: String
var reward_string: String

func _ready() -> void:
	await get_tree().process_frame
	claim_button.connect("pressed", Callable(self, "_on_claim_button_pressed"))
	
func set_reward_string():
	if rewards.gems.mantissa:
		reward_string = "[center][b][color=#000000]%s[/color][/b][/center]" % rewards.gems
	else:
		reward_string = "[center][b][color=#000000]%s[/color][/b][/center]" % rewards.money

func complete() -> void:
	is_completed = true
	update_status()

func update_status():
	if is_completed:
		claim_button.disabled = false
		target_text.text = "[center][b]Claim[/b][/center]"
		print(target_text.text)
		

func _on_claim_button_pressed() -> void:
	if is_completed:
		Globals.add_gems(rewards.gems)
		Globals.add_money(rewards.money)
		emit_signal("mission_completed", self)
		
