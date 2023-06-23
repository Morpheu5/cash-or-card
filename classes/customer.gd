extends Object
class_name Customer

var name: String = "Ciccio Pasticcio"
var prefers_cash: int = randi_range(0, 3)
var denial_tolerance: int = randi_range(1, 3)
var initial_denial_tolerance = denial_tolerance
var must_use_cash: bool = true if randf() < 0.05 else false
var returning: bool = false
var payment_method: Dictionary = {}

func set_name(val: String = "Ciccio Pasticcio"):
	name = val
	return self

func set_prefers_cash(val: int = 1):
	prefers_cash = val
	return self

func set_denial_tolerance(val: int = 1):
	denial_tolerance = val
	return self

func set_must_use_cash(val: bool = false):
	must_use_cash = val
	return self

func set_returning(val: bool = false):
	returning = val
	return self

func set_payment_method(val: Dictionary = {}):
	payment_method = val
	return self

func decrement_cash_preference():
	set_prefers_cash(max(0, prefers_cash-1))
	print("Decrement cash preference...\n", self)

func decrement_denial_tolerance():
	set_denial_tolerance(max(0, denial_tolerance-1))
	print("Decrement denial tolerance...\n", self)

func _to_string() -> String:
	return "%s\n\tmust use cash: %s\n\tprefers cash: %d\n\tdenial tolerance: %d\n\tpayment method: %s\n" % [name, must_use_cash, prefers_cash, denial_tolerance, payment_method.method_id]
