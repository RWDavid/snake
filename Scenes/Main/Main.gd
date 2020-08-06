extends Node

const scene_food = preload("res://Entities/Food/Food.tscn")
const scene_mouth = preload("res://Entities/Mouth/Mouth.tscn")

onready var grid = $Grid

var player: Node2D

func _ready():
	randomize()
	setup_entities()

func setup_entities():
	player = scene_mouth.instance() as Node2D
	player.connect("directional_move", self, "_on_Mouth_directional_move")
	player.connect("body_segment_move", self, "_on_Mouth_body_segment_move")
	player.connect("generated_tail_segment", self, "_on_Mouth_generated_tail_segment")
	player.connect("snake_size_changed", self, "_on_Mouth_snake_size_changed")
	add_child(player)
	grid.place_entity_at_random_pos(player)
	create_food_instance()
	
func create_food_instance():
	var food_instance = scene_food.instance() as Node2D
	add_child(food_instance)
	grid.place_entity_at_random_pos(food_instance)

func _on_Mouth_directional_move(entity: Node2D, direction: Vector2):
	grid.move_entity_in_direction(entity, direction)

func _on_Grid_moved_into_death():
	play_audio("res://Scenes/Main/gameover.wav")
	delete_entities_of_group("Food")
	delete_entities_of_group("Player")
	setup_entities()

func delete_entities_of_group(name: String):
	var entities = get_tree().get_nodes_in_group(name)
	for entity in entities:
		entity.queue_free()

func _on_Grid_moved_onto_food(food_entity: Node2D, entity: Node2D):
	if entity.has_method("eat_food"):
		entity.eat_food()
		play_audio("res://Scenes/Main/eat.wav")
		food_entity.queue_free()
		create_food_instance()

func _on_Mouth_generated_tail_segment(segment: Node2D, segment_position: Vector2):
	add_child(segment)
	grid.place_entity(segment, grid.world_to_map(segment_position))

func _on_Mouth_body_segment_move(segment: Node2D, segment_position: Vector2):
	grid.set_entity_of_cell(null, grid.world_to_map(segment.position))
	grid.place_entity(segment, grid.world_to_map(segment_position))

func _on_Mouth_snake_size_changed(length: int):
	$CanvasLayer/HUD/SnakeLength.set_text(str(length))

func play_audio(file_path):
	var sound = AudioStreamPlayer.new()
	self.add_child(sound)
	sound.stream = load(file_path)
	sound.play()
	sound.connect("finished", sound, "queue_free")
