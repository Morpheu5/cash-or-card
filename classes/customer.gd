extends Object
class_name Customer

var name: String = "Ciccio Pasticcio"
var must_use_cash: bool = true if randf() < 0.05 else false
var prefers_cash: int = 1000 if must_use_cash else randi_range(0, 3)
var denial_tolerance: int = randi_range(2, 4)
var initial_denial_tolerance = denial_tolerance
var returning: bool = false
var payment_method: String

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

func set_payment_method(val: String):
	payment_method = val
	return self

func decrement_cash_preference(by = 1):
	set_prefers_cash(max(0, prefers_cash - by))
	return self

func decrement_denial_tolerance(by = 1):
	set_denial_tolerance(max(0, denial_tolerance - by))
	return self

func _to_string() -> String:
	return	"%s
			   must use cash: %s
			   prefers cash: %d
			   denial tolerance: %d
			   initial denial tolerance: %d
			   payment method: %s
			" % [
			name,
			must_use_cash,
			prefers_cash,
			denial_tolerance,
			initial_denial_tolerance,
			payment_method,
			]
