extends Node2D

var value = 0
@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = str(value)

func setPointToShow(points):
	label.text = str(points)
