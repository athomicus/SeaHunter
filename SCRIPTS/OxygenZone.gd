extends Area2D

const ZoneRefillOxygen = preload("res://player/player_surface.ogg")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("Player"):
		if Global.saved_people_count >= 7:
			GameEvents.emit_signal("full_crew_oxygen_refuel")
			#print("full_signal")
		else:
			GameEvents.emit_signal("less_crew_oxygen_refuel")
			#print("less_signal")
		SoundManager.play_sound(ZoneRefillOxygen)
