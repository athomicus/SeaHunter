extends Node


var saved_people_count = 0
var oxygen_level = 100
var Points = 0
var highScore = 0
#      LIMITS
const SCREEN_MAXX = 300
const SCREEN_MINX = -50

func reset_stat():
	Points = 0
	oxygen_level = 100
	saved_people_count = 0
	
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
