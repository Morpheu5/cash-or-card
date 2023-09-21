extends Node2D



func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(meta)


func _on_back_button_pressed():
	queue_free()
