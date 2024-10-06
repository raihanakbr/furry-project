extends Node2D

class_name ArcadeMachine
signal money_generated(amount: ScientificNumber)
@onready var upgrade_panel := $Panel as Panel
@onready var upgrade_sign := $Sprite2D/UpgradeButton as Button
@onready var upgrade_button := $Panel/UpgradeButton as Button
@onready var name_label := $Panel/VBoxContainer/NameLabel as RichTextLabel
@onready var level_label := $Panel/VBoxContainer/LevelLabel as RichTextLabel
@onready var old_label := $Panel/TextureRect/OldLabel as RichTextLabel
@onready var new_label := $Panel/TextureRect2/NewLabel as RichTextLabel
@onready var cost_label := $Panel/UpgradeButton/TextureRect/CostLabel as RichTextLabel

var isOccupied: bool = false
var money_per_played = ScientificNumber.new(1,1)
var level : int  = 0
var upgrade_cost = ScientificNumber.new(1,2)
var machine_name = "Machine Type 1"
var money_inc = ScientificNumber.new(3,0)
static var buy_cost = ScientificNumber.new(1,2)

func _ready() -> void:
	Globals.arcadeGames.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.money.compare(upgrade_cost) >= 1:
		upgrade_button.disabled = false
		upgrade_sign.visible = true
	else:
		upgrade_button.disabled = true
		upgrade_sign.visible = false
	_update_label()

func generate_money():
	Globals.add_money(money_per_played)
	emit_signal("money_generated", money_per_played)

func _upgrade():
	Globals.sub_money(upgrade_cost)
	money_per_played = money_per_played.add(money_inc)
	level += 1
	if (level+1) % 10 == 0 && ((level+1)/10) & ((level+1)/10-1) == 0:
		upgrade_cost = upgrade_cost.mult(2)
		money_inc = money_inc.mult(4)
	elif (level) % 10 == 0 && ((level)/10) & ((level)/10-1) == 0:
		money_inc = money_inc.div(2)
		upgrade_cost = upgrade_cost.add(money_inc.mult(15))
	else:
		upgrade_cost = upgrade_cost.add(money_inc.mult(15))

func _on_upgrade_button_pressed() -> void:
	if Globals.money.compare(upgrade_cost) >= 1:
		_upgrade()


func _on_button_pressed() -> void:
	if !upgrade_panel.visible:
		for arcade in Globals.arcadeGames:
			var panel = arcade.get_node("Panel")
			if panel:
				panel.visible = false
		upgrade_panel.visible = true
		upgrade_panel.z_index = 10
	else:
		upgrade_panel.visible = false
	
func _update_label() -> void:
	name_label.text = "[center][color=#696969]%s[/color][/center]" % machine_name
	level_label.text = "[center][b][color=#000000]Level %d[/color][/b][/center]" % level
	old_label.text = "[center][b][color=#000000]%s[/color][/b][/center]" % money_per_played
	new_label.text = "[center][b][color=#000000]%s[/color][/b][/center]" % (money_per_played.add(money_inc))
	cost_label.text = "[b][color=#000000]%s[/color][/b]" % upgrade_cost
