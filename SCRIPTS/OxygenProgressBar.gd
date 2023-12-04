extends Node2D

@onready var oxygenProgressBar = $OxygenProgressBar
@onready var flash_timer = $FlashTimer
const oxygenAlertSound = preload("res://user_interface/oxygen-bar/oxygen_alert.ogg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	oxygenProgressBar.value = Global.oxygen_level
	
	var amount_rounded = round(Global.oxygen_level)
	if amount_rounded == 25:
		scale = Vector2(1.25,1.25)
		rotation_degrees =  randf_range(-3,3) 
		modulate = Color(20,1,1)
		SoundManager.play_sound(oxygenAlertSound)
		flash_timer.start()
			
func _physics_process(delta):
	scale = lerp(scale, Vector2(1,1) , 6 * delta)
	rotation_degrees = lerp(rotation_degrees , 0.0 , 6  * delta)
	


func _on_flash_timer_timeout():
	modulate = Color(1,1,1)
