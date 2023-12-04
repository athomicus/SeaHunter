extends Area2D

@onready var _sprite = $AnimatedSprite2D
var velocity = Vector2(1,0)
const SPEED = 25
var point_value = 30
const savePeopleSound = preload("res://person/saving_person.ogg")
const deathSound = preload("res://person/person_death.ogg")
const popUp = preload("res://points_pop_up.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += velocity * delta * SPEED


func _process(delta):
	if global_position.x >  Global.SCREEN_MAXX or global_position.x <Global.SCREEN_MINX:
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("Player") and Global.saved_people_count < 7:
		Global.saved_people_count +=1
		GameEvents.emit_signal("update_people_count")
		Global.Points += point_value
		GameEvents.emit_signal("updates_points")
		SoundManager.play_sound(savePeopleSound)
		popUpPoints()
		queue_free()
	elif area.is_in_group("player_bullets"): #kill person
		SoundManager.play_sound(deathSound)
		area.queue_free()
		queue_free()
			
func flip_direction():
	velocity = -velocity
	_sprite.flip_h = !_sprite.flip_h
	
	
func popUpPoints():
	var pointPopUpinstance = popUp.instantiate()
	
	get_tree().current_scene.add_child(pointPopUpinstance)
	
	#pointPopUpinstance.value = point_value
	pointPopUpinstance.setPointToShow(point_value)
	pointPopUpinstance.global_position = global_position
