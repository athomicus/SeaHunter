extends Control

@onready var gameOverDelayTimer = $GameOverDealy
@onready var current_score_label = $Score
@onready var high_score_label = $HighScore
const gameOverSound = preload("res://player/game_over.ogg")
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_over", Callable(self,"_activate_game_over"))
	visible = false

func _activate_game_over():
	current_score_label.text = "Score " + str(Global.Points)
	if Global.Points > Global.highScore:
		Global.highScore = Global.Points
	high_score_label.text = "HighScore " + str(Global.highScore)
	gameOverDelayTimer.start()
	
func _process(delta): #reload Scene
	
	if Input.is_action_just_pressed("shoot") and visible == true:
		Global.reset_stat()
		get_tree().reload_current_scene()

func _on_game_over_dealy_timeout():
	visible = true
	SoundManager.play_sound(gameOverSound)
