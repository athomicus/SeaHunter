extends Area2D

const SPEED = 50
const MOVEMENT_FREQ = 0.15
const AMPLITUDE = 0.5
var point_value = 25
var current_state="default"
const sharkDie = preload("res://enemies/shark/shark_death.ogg")
const object_pieces = preload("res://particles/object_pieces.tscn")
const PIECE_COUNT = 2
const valuePopUp = preload("res://points_pop_up.tscn")

@onready var _spriteShark = $Animationsprite
var velocity = Vector2(1,0)

func _ready():
	GameEvents.connect("pause_enemy",Callable(self,"_pause"))
	GameEvents.connect("kill_all_enemy", Callable(self,"_death_to_all"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x >  Global.SCREEN_MAXX or global_position.x <Global.SCREEN_MINX:
		#flip_direction()\
		queue_free()
		


func _physics_process(delta):
	if current_state == "default":
		velocity.y  = sin(global_position.x * MOVEMENT_FREQ ) * AMPLITUDE
		global_position += velocity * SPEED * delta

#area z enemy(shark)  wysyła ze co go dotknelo - bullet
# i kasuje rekina w area przekazywane jest co go dotknelo przez Area
# w tym przypadku area z bulleta (kuli)
#area.get_parent().queue_free() skasuj parenta co dotknal rekina

func flip_direction():
	velocity = -velocity
	_spriteShark.flip_h = !_spriteShark.flip_h

#  area z bullet node
func _on_area_entered(area):
	if area.is_in_group("player_bullets"):
		Global.Points += point_value
		GameEvents.emit_signal("updates_points")
		SoundManager.play_sound(sharkDie)
		area.queue_free()
		queue_free()
		instance_death_pieces()
		popUpPoints()
	if area.is_in_group("Player"):
		GameEvents.emit_signal("game_over")
		
func _death_to_all():
	Global.Points += point_value
	GameEvents.emit_signal("updates_points")
	instance_death_pieces()
	queue_free()
	popUpPoints()
	
func _pause(pause):
	if pause:
		current_state = "pause"
	else:
		current_state = "default"
		
func instance_death_pieces():
	for i in range(PIECE_COUNT):
		var piece_instantiate = object_pieces.instantiate()
		piece_instantiate.frame = i
		get_tree().current_scene.add_child(piece_instantiate)
		piece_instantiate.global_position = global_position
		
		
func popUpPoints():
	var pointPopUpinstance = valuePopUp.instantiate()
	
	get_tree().current_scene.add_child(pointPopUpinstance)
	
	#pointPopUpinstance.value = point_value
	pointPopUpinstance.setPointToShow(point_value)
	pointPopUpinstance.global_position = global_position
		
