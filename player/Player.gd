extends Area2D
var isShooting = false
var  velocity = Vector2(0,0)
const SPEED  = Vector2(125,90)
const OXYGEN_DECREASE_SPEED = 2.5
var can_shoot = true
const BULLETOFFSET =  7
#@onready var _player = get_node("Player")
const Bullet  = preload("res://player/bullet.tscn")
var state = "default"
const OXYGEN_REFUEL_POSITION = 28 
const MAX_X_POSITION = 244
const MIN_X_POSITION = 13
const MAX_Y_POSITION = 185
const MIN_Y_POSITION = OXYGEN_REFUEL_POSITION 
const shootSound = preload("res://sound_manager/shoot_short.wav")
const playerDeathSound = preload("res://player/player_death.ogg")
const oxygenFullSound = preload("res://player/player_refuel_oxygen.ogg")
const OBJECT_PIECES = 10
const ObjectPieces = preload("res://particles/object_pieces.tscn")
const PieceTexture = preload("res://player/player_pieces.png")
const ROTATION_MOVE = 15
@onready var _reloadTimer = $ReloadTimer
@onready var _sprite = $AnimatedSprite2D
@onready var decrease_people_timer = $DecreasingPeople

func _ready(): 
	GameEvents.connect("full_crew_oxygen_refuel",Callable(self, "_full_crew_oxygen"))
	GameEvents.connect("less_crew_oxygen_refuel",Callable(self, "_less_crew_oxygen"))
	GameEvents.connect("game_over",Callable(self, "_game_over"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if state == "default":
		process_movement_input()
		direction_follow()
		process_shooting()
		decrease_oxygen_level()
		die_low_oxygen()
		
		
	elif state == "oxygen_refuel":
		
		oxygen_refuel()
		move_to_shore_line()
	elif state == "people_refuel":
		oxygen_refuel()
		move_to_shore_line()

func process_movement_input():
	velocity.x = Input.get_axis("move_left","move_right")
	velocity.y = Input.get_axis("move_up","move_down")	
	velocity = velocity.normalized()
			
func direction_follow():
	if isShooting:
		return
	if velocity.x > 0:
		_sprite.flip_h = false
	elif velocity.x < 0:
		_sprite.flip_h = true

func process_shooting():
	if Input.is_action_pressed("shoot") and can_shoot == true: 
		var bullet_instance = Bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		SoundManager.play_sound(shootSound)
		
		
		if _sprite.flip_h:
			#bullet_instance.velocity.x = -1
			#bullet_instance.flip_h = true 
			bullet_instance.flip_direction()
			bullet_instance.global_position = global_position - Vector2(BULLETOFFSET, 0)
		else:
			bullet_instance.global_position = global_position + Vector2(BULLETOFFSET, 0)
		
		can_shoot = false
		_reloadTimer.start()
	if Input.is_action_pressed("shoot"):
		isShooting=true
	else:
		isShooting = false 
	
func _physics_process(delta):  #
	if state == "default":
		movement()
		rotate_when_move()
	clamp_position()
	GameEvents.emit_signal("camera_follow_player",global_position.y)
	
func decrease_oxygen_level():
	#if Global.oxygen_level > 0:
	#	Global.oxygen_level -= OXYGEN_DECREASE_SPEED * delta 
	var deltaOxygen =  OXYGEN_DECREASE_SPEED * get_process_delta_time()
	Global.oxygen_level = move_toward(Global.oxygen_level,0,deltaOxygen)
	#print(Global.oxygen_level)

func movement():
	#global_position += velocity * SPEED * delta 
	global_position += velocity * SPEED * get_process_delta_time()

func _on_reload_timer_timeout():
	can_shoot = true
	#print("reload complete")

func remove_one_person():
	if Global.saved_people_count > 0:
		Global.saved_people_count -= 1
		GameEvents.emit_signal("update_people_count")
		
func _full_crew_oxygen():
	#print("full")
	state = "people_refuel"
	_sprite.play("flash")
	decrease_people_timer.start()
	refill_oxygen_when_you_are80percent()
	GameEvents.emit_signal("pause_enemy",true)
	GameEvents.emit_signal("kill_all_enemy")


func _less_crew_oxygen():
	_sprite.play("flash")
	#print("refuel less ")
	remove_one_person()
	state = "oxygen_refuel"
	refill_oxygen_when_you_are80percent()
	GameEvents.emit_signal("pause_enemy",true)
	
func move_to_shore_line():
	var move_speed = 50 * get_process_delta_time()
	global_position.y = move_toward(global_position.y,OXYGEN_REFUEL_POSITION , move_speed)
	
func clamp_position():
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION,MAX_Y_POSITION)
	
func oxygen_refuel():
	Global.oxygen_level += 60 * get_process_delta_time()
 
		
	if Global.oxygen_level > 99:
		Global.oxygen_level = 100
		state = "default"
		_sprite.play("default")
		GameEvents.emit_signal("pause_enemy",false)
		SoundManager.play_sound(oxygenFullSound)


func _on_decreasing_people_timeout():
	remove_one_person()
	if Global.saved_people_count <=0:
		decrease_people_timer.stop()
		
func _game_over():
	instantiate_player_pieces()
	SoundManager.play_sound(playerDeathSound)
	queue_free()
	
func die_low_oxygen():
	if Global.oxygen_level<=0:
		GameEvents.emit_signal("game_over")
		GameEvents.emit_signal("pause_enemy",true)
		
func refill_oxygen_when_you_are80percent():
	if Global.oxygen_level>80:
		GameEvents.emit_signal("game_over")
		GameEvents.emit_signal("pause_enemy",true)

func instantiate_player_pieces():
	for i in range(10):
		var playerPiecesInstance = ObjectPieces.instantiate()
		playerPiecesInstance.texture = PieceTexture
		playerPiecesInstance.hframes = 10
		playerPiecesInstance.frame = i
		get_tree().current_scene.add_child(playerPiecesInstance)
		playerPiecesInstance.global_position = global_position
	
func rotate_when_move():
	
	var rotation_target = velocity.x * ROTATION_MOVE
	var rotation_speed  = 10 * get_physics_process_delta_time()
	#rotation_degrees = rotation_target * rotation_speed
	rotation_degrees = lerp(rotation_degrees,rotation_target,rotation_speed)
	
