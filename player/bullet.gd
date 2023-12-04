extends Area2D

var velocity = Vector2(1,0)
const SPEED = 300
@onready var _sprite = $Bullet
# Called when the node enters the scene tree for the first time.

func _ready():
		rotation_degrees = randf_range(-7,7)
		velocity = velocity.rotated(rotation)

func _physics_process(delta):
	global_position += velocity * SPEED * delta


func flip_direction():
	velocity = -velocity
	_sprite.flip_h = !_sprite.flip_h


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
