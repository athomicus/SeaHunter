extends Sprite2D

var  velocity = Vector2(0,0)
const SPEED  = Vector2(125,90)
var can_shoot = true
 
func _process(delta):
	velocity.x = Input.get_axis("move_left","move_right")
	velocity.y = Input.get_axis("move_up","move_down")	
	velocity = velocity.normalized()

func _physics_process(delta):   
	global_position += velocity * SPEED * delta 

 
