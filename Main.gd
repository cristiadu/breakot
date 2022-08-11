extends Node2D

signal game_over
signal game_won

export var total_levels = 2
var current_level_number = 1
var current_level = null
var active_blocks_count


func _ready():
	$StartGameTimer.connect("timeout", self, "run_game")
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
	
	var blocks = get_tree().get_nodes_in_group("block")
	active_blocks_count = blocks.size()
	for block in blocks:
		block.connect("hit", self, "check_level_win")

	$HUD.show_message("Starting Game...")
	$StartGameTimer.start()


func check_level_win():
	active_blocks_count-=1
	if active_blocks_count == 0:
		if current_level_number < total_levels:
			$HUD.show_message("You Won This Level! Loading next one...")
			current_level_number += 1
			yield(get_tree().create_timer(10), "timeout")
			start_level(current_level_number)
		else:
			$HUD.show_message("You Won The Game! :D :D :D")
