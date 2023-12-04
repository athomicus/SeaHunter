extends Camera2D

const FOLLOW_SPEED = 5
const MIN = 70
const MAX = 145
var target_position = global_position
func _ready():
	GameEvents.connect("camera_follow_player",Callable(self,"_follow_player"))
	

func _physics_process(delta):
	global_position.y = lerp(global_position.y,target_position.y, 7 * delta)

func _follow_player(player_y):
	target_position.y = clamp(player_y,MIN,MAX)
