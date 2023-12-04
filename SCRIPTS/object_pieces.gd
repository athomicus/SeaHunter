extends Sprite2D

var velocity = Vector2(1,0)
var move_speed: float = 150
var rotation_speed = 50
const TWO_PI = 6.28

func _ready():
	velocity = velocity.rotated(randf_range(0,TWO_PI))
	#velocity = velocity.rotated(deg_to_rad(randf_range(0,360)))

func _physics_process(delta):
	global_position += velocity * move_speed * delta
	rotation_degrees += rotation_speed *  2  * delta
	
	move_speed = lerp(move_speed, 0.0, 6*delta)

func destroy_pieces():
	queue_free()
