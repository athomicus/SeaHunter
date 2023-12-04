extends Sprite2D

const EMPTY_TEXTURE = preload("res://user_interface/people-count/person_empty_ui.png")
const FULL_TEXTURE = preload("res://user_interface/people-count/person_ui.png")

@export var order_number = 1 

func _ready():
	GameEvents.connect("update_people_count", Callable(self, "_update"))


func _update():
	if Global.saved_people_count >=7:
		frame = 1
	else:
		frame=0
	
	if Global.saved_people_count >= order_number:
		texture = FULL_TEXTURE
	else:
		texture = EMPTY_TEXTURE
 
