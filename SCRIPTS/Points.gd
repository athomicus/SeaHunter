extends Label

func _ready():
	GameEvents.connect("updates_points",Callable(self,"_update_points"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
 
	

func _update_points():
	text = str(Global.Points)
	
