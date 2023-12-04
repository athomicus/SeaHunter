extends Marker2D

@export var  facing_left = false
const Enemy = preload("res://enemies/shark.tscn")

@onready var t = $Timer

func _ready():
	t.wait_time = randf_range(1,5)


func _on_timer_timeout():
	var spawnShark = Enemy.instantiate()
	get_tree().current_scene.add_child(spawnShark)
	spawnShark.global_position = global_position
	if facing_left:
		spawnShark.flip_direction()
		
	t.wait_time = randf_range(1,3)
