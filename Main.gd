extends Node2D

export var total_levels = 5

var game_started = false
var current_level_number = 1
var current_level = null


func _ready():
	var err = $HUD.connect("level_won", self, "on_level_won")
	if err:
		print("Error when linking behavior of winning a level")
		
	err = $HUD.connect("level_lost", self, "on_level_lost")
	if err:
		print("Error when linking behavior of losing a level")
		
	err = $Ball.connect("lost_life", self, "on_life_lost")
	if err:
		print("Error when linking behavior of losing a life")
		
	err = $StartGameTimer.connect("timeout", self, "run_game")
	if err:
		print("Error when linking behavior of run_game timer")


func _process(_delta):
	if (not game_started) and Input.is_action_pressed("ui_accept"):
		game_started = true
		start_level(1)
	if Input.is_action_pressed("ui_cancel"):
		$Ball.sleeping = true
		game_started = false
		$HUD.show_title_screen()


func on_level_won():
	$Ball.sleeping = true
	if current_level_number < total_levels:
		$HUD.show_message("You Won This Level!\nLoading next one...")
		current_level_number += 1
		yield(get_tree().create_timer(3), "timeout")
		start_level(current_level_number)
	else:
		$HUD.show_message("You Won The Game!\nPress ESC to go back to title screen.", false)


func on_level_lost():
	$Ball.sleeping = true
	$HUD.show_message("Game Over!\nPress ESC to go back to title screen.", false)


func on_life_lost():
	$Ball.sleeping = true
	$Ball.reset(current_level.get_node("StartingBallPosition").position)
	$HUD.life_lost()


func run_game():
	$Ball.reset(current_level.get_node("StartingBallPosition").position)
	$Paddle.reset(current_level.get_node("StartingPaddlePosition").position)
	$HUD.reset()


func start_level(level_number):
	# Load new level scene dinamically
	if current_level != null:
		current_level.queue_free()
		
	var level_name = "Level" + str(level_number)
	var level_to_load = load("res://levels/" + level_name + ".tscn")
	current_level = level_to_load.instance()
	current_level.set_name(level_name)
	add_child_below_node($CollisionWalls, current_level)
	$HUD.hide_title_screen()
	$HUD.show_message("Starting Game...")
	$StartGameTimer.start()
