extends Node2D

signal game_over
signal game_won

export var total_levels = 2
var game_started = false
var current_level_number = 1
var current_level = null



func _ready():
	$HUD.connect("level_won", self, "level_won")
	$StartGameTimer.connect("timeout", self, "run_game")


func _process(delta):
	if (not game_started) and Input.is_action_pressed("ui_accept"):
		game_started = true
		start_level(current_level_number)


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


func level_won():
	$Ball.sleeping = true
	game_started = false
	if current_level_number < total_levels:
		$HUD.show_message("You Won This Level! Loading next one...")
		current_level_number += 1
		yield(get_tree().create_timer(3), "timeout")
		start_level(current_level_number)
	else:
		$HUD.show_message("You Won The Game! :D :D :D", false)
