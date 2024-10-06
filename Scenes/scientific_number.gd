extends Node
class_name ScientificNumber
var mantissa: float
var exponent: int
static var ZERO = ScientificNumber.new(0,0)

func _init(mantissa: float, exponent: int):
	self.mantissa = mantissa
	self.exponent = exponent

func add(other: ScientificNumber) -> ScientificNumber:
	var copy = ScientificNumber.new(self.mantissa, self.exponent)
	if copy.exponent == other.exponent:
		copy.mantissa += other.mantissa
	elif copy.exponent > other.exponent:
		var exponent_diff = copy.exponent - other.exponent
		var adjusted_mantissa = other.mantissa / pow(10, exponent_diff)
		copy.mantissa += adjusted_mantissa
	else:
		var exponent_diff = other.exponent - copy.exponent
		copy.mantissa = copy.mantissa / pow(10, exponent_diff)
		copy.mantissa += other.mantissa
		copy.exponent = other.exponent
	while copy.mantissa >= 10.0:
		copy.mantissa /= 10.0
		copy.exponent += 1
	return copy

func sub(other: ScientificNumber) -> ScientificNumber:
	var copy = ScientificNumber.new(self.mantissa, self.exponent)
	if copy.exponent == other.exponent:
		copy.mantissa -= other.mantissa
	elif copy.exponent > other.exponent:
		var exponent_diff = copy.exponent - other.exponent
		var adjusted_mantissa = other.mantissa / pow(10, exponent_diff)
		copy.mantissa -= adjusted_mantissa
	else:
		var exponent_diff = other.exponent - copy.exponent
		copy.mantissa = copy.mantissa / pow(10, exponent_diff)
		copy.mantissa -= other.mantissa
		copy.exponent = other.exponent
	while copy.mantissa < 1 && copy.mantissa > 0:
		copy.mantissa *= 10.0
		copy.exponent -= 1
	return copy

func mult(other) -> ScientificNumber:
	var copy = ScientificNumber.new(self.mantissa, self.exponent)
	if other is ScientificNumber:
		copy.exponent += other.exponent
		copy.mantissa *= other.mantissa
	else:
		copy.mantissa *= other
	while copy.mantissa >= 10.0:
		copy.mantissa /= 10.0
		copy.exponent += 1
	return copy

func div(other) -> ScientificNumber:
	var copy = ScientificNumber.new(self.mantissa, self.exponent)
	if other is ScientificNumber:
		copy.exponent -= other.exponent
		copy.mantissa /= other.mantissa
	else:
		copy.mantissa /= other
	while copy.mantissa < 1 && copy.mantissa > 0:
		copy.mantissa *= 10.0
		copy.exponent -= 1
	return copy
	
func get_suffix() -> String:
	var suffixes = "abcdefghijklmnopqrstuvwxyz"
	var index = int(exponent / 3) - 1
	return suffixes[index] if index >= 0 and index < suffixes.length() else ""

func _to_string() -> String:
	var adjusted_mantissa = mantissa
	var adjusted_exponent = exponent % 3 
	
	for i in range(adjusted_exponent):
		adjusted_mantissa *= 10.0
	
	return str(round(adjusted_mantissa * 100) / 100.0) + " " + get_suffix()

# 0: self < other, 1: self == other, 2: self > other
func compare(other : ScientificNumber) -> int:
	if exponent < other.exponent:
		return 0
	elif exponent > other.exponent:
		return 2
	else:
		if mantissa < other.mantissa:
			return 0
		elif mantissa == other.mantissa:
			return 1
		else:
			return 2
