extends Node2D

class_name Mouth

signal directional_move(entity, direction)
signal generated_tail_segment(segment, segment_position)
signal body_segment_move(segment, segment_position)
signal snake_size_changed(length)

var direction = Vector2()
var last_move_direction = Vector2()
var buffer_direction = Vector2()
var body_segments = [self]
var dead = false # needed in order to stop asynchronous bugs when moving body segments

const scene_tail = preload("res://Entities/Tail/Tail.tscn")

func _ready():
	$PlayerInput.connect("directional_input_detected", self, "_on_PlayerInput_directional_input_detected")
	emit_signal("snake_size_changed", body_segments.size())

func _on_PlayerInput_directional_input_detected(new_direction):
	if direction == Vector2():
		direction = new_direction
		return
	
	if buffer_direction != Vector2():
		return

	if direction != last_move_direction * -1 and direction != last_move_direction \
		and new_direction != direction and new_direction != direction * -1:
		buffer_direction = new_direction
		return

	if new_direction != last_move_direction * -1:
		direction = new_direction

func _on_Timer_timeout():
	if direction != Vector2():
		last_move_direction = direction
		if buffer_direction != Vector2():
			direction = buffer_direction
			buffer_direction = Vector2()
		
		var next_pos = self.position
		emit_signal("directional_move", self, last_move_direction)
		if body_segments.size() > 1:
			
			# Body segments need to be deleted if the mouth of the snake
			# causes the snake to die.
			# Therefore, we must stop the body segments from moving.
			if dead:
				dead = false
				return
			
			for i in range(1, body_segments.size()):
				var temp_pos = body_segments[i].position
				emit_signal("body_segment_move", body_segments[i], next_pos)
				next_pos = temp_pos

func eat_food():
	var tail_segment = scene_tail.instance() as Node2D
	body_segments.append(tail_segment)
	emit_signal("generated_tail_segment", tail_segment, body_segments[-2].position)
	emit_signal("snake_size_changed", body_segments.size())
