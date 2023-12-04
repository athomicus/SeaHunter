extends Node2D

@onready var left = $Left
@onready var right = $Right
@onready var enemySpawner = $Timer

const Shark = preload("res://enemies/shark.tscn")
const Person = preload("res://person.tscn")

func _ready():
	GameEvents.connect("pause_enemy", Callable(self,"_pauseOrNot"))

func _on_timer_timeout():
	for i in range(4):
		spawn_enemy()

func _pauseOrNot(pause):
	if pause:
		enemySpawner.stop()
	else:
		enemySpawner.start()


func spawn_enemy():
	var rand_spawn_int = randi_range(1,4)
	
	var selected_node = left
	var direction_lef_right = bool(randi_range(0,1))
	
	var shark_instance = Shark.instantiate()
	get_tree().current_scene.add_child(shark_instance)
	
	if direction_lef_right:
		selected_node = right
		shark_instance.flip_direction()
	
	var selected_spawn_point = selected_node.get_node(str(rand_spawn_int))	
	var spawn_position = selected_spawn_point.global_position
	

	shark_instance.global_position = spawn_position
	
	
	


func _on_timer_person_spawner_timeout():
	var person_instance = Person.instantiate()
	get_tree().current_scene.add_child(person_instance)
	
	var selected_spawn_number = randi_range(1,4)
	
	var selected_node = left
	var direction_lef_right = bool(randi_range(0,1))
	if direction_lef_right:
		selected_node = right
		person_instance.flip_direction()
	
	var selected_spawn_point = selected_node.get_node(str(selected_spawn_number))
	var spawn_position = selected_spawn_point.global_position
	
	person_instance.global_position = spawn_position

