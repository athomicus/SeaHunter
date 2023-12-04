extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("finished", Callable(self,"_finished"))
	
func _finished():
	queue_free()#destroy sound effect
