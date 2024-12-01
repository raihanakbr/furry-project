extends Node

var mission_list: Array[Mission] = [null, null, null]
var arcadeGames: Array[Node2D]
var money = ScientificNumber.new(6969,6969)
var gems = ScientificNumber.new(6969,6969)
var affections: Array[int] = [0]
var http_request = HTTPRequest.new()
var is_choosing_arcade = false

func add_money(money: ScientificNumber) -> void:
	self.money = self.money.add(money)

func sub_money(money: ScientificNumber) -> void:
	self.money = self.money.sub(money)
		
func add_gems(gems: ScientificNumber) -> void:
	self.gems = self.gems.add(gems)

func sub_gems(gems: ScientificNumber) -> void:
	self.gems = self.gems.sub(gems)
