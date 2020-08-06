extends Node

class_name PlayerInput

signal directional_input_detected

func _input(event):
	var direction = Vector2(0, 0)
	if event.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
	elif event.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
	elif event.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
	elif event.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
	if direction:
		emit_signal("directional_input_detected", direction)
