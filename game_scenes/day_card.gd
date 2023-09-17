extends ColorRect

signal open_shop_button_pressed




func _on_open_shop_button_pressed():
	open_shop_button_pressed.emit()
