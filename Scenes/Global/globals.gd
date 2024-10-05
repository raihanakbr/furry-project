extends Node

var arcadeGames: Array[Node2D]
var money: int
var gems: int
var http_request = HTTPRequest.new()

func add_money(money: int) -> void:
	if money > 0:
		self.money += money

func sub_money(money: int) -> void:
	if money > 0:
		self.money -= money
		
func add_gems(gems: int) -> void:
	if gems > 0:
		self.gems += gems

func sub_gems(gems: int) -> void:
	if gems > 0:
		self.gems -= gems
