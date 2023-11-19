extends Node2D

@export var total_levels = 5

var game_started = false
var game_paused = false
var game_muted = false
var current_level_number = 0
var current_level = null


func _ready():
	var err = $HUD.level_won.connect(on_level_won)
	if err:
		print("Error when linking behavior of winning a level")
		
	err = $HUD.level_lost.connect(on_level_lost)
	if err:
		print("Error when linking behavior of losing a level")
		
	err = $Ball.lost_life.connect(on_life_lost)
	if err:
		print("Error when linking behavior of losing a life")
		
	err = $StartGameTimer.timeout.connect(run_game)
	if err:
		print("Error when linking behavior of run_game timer")
		
	$HUD.show_title_screen()


func _process(_delta):
	if $HUD/TitleBackground.visible and Input.is_action_just_pressed("ui_accept"):
		# Game can be re-initalized only from title screen.
		current_level_number = 1
		$StartGameSound.play()
		start_level(current_level_number)
	if Input.is_action_just_pressed("ui_cancel") and not $HUD/TitleBackground.visible:
		# Cancel can happen at any time if game is being played or initialized, so whenever title screen isn't there.
		game_started = false
		pause_game_objects()
		$CancelSound.play()
		$StartGameTimer.stop()
		$HUD.show_title_screen()
	if Input.is_action_just_pressed("ui_pause") and game_started:
		# Game can only be paused if it was already initialized.	
		game_paused = not game_paused # new state of game_paused boolean after "P" is pressed again.
		if game_paused:
			pause_game_objects()
			$HUD.show_message("GAME PAUSED.", false)
		else:
			unpause_game_objects()
			$HUD.on_timeout_hide_message()
	if Input.is_action_just_pressed("ui_mute"):
		mute_or_unmute_sound(not game_muted)


func on_level_won():
	pause_game_objects()
	if current_level_number < total_levels:
		$LevelWonSound.play()
		$HUD.show_message("You Won This Level!\nLoading next one...")
		current_level_number += 1
		await get_tree().create_timer(3).timeout
		start_level(current_level_number)
	else:
		$GameWonSound.play()
		game_started = false
		$HUD.show_message("You Won The Game!\nPress ESC to go back to title screen.", false)


func on_level_lost():
	game_started = false
	pause_game_objects()
	$GameLostSound.play()
	$HUD.show_message("Game Over!\nPress ESC to go back to title screen.", false)


func on_life_lost():
	$LifeLostSound.play()
	$Ball.pause()
	$Ball.reset(current_level.get_node("StartingBallPosition").position)
	$HUD.life_lost()


func run_game():
	game_started = true
	$Ball.reset(current_level.get_node("StartingBallPosition").position)
	$Paddle.reset(current_level.get_node("StartingPaddlePosition").position)
	$HUD.reset()


func start_level(level_number):
	# Load new level scene dinamically
	if current_level != null:
		var previous_level = current_level
		remove_child(previous_level)
		previous_level.queue_free()
		
	var level_name = "Level" + str(level_number)
	var level_to_load = load("res://levels/" + level_name + ".tscn")
	current_level = level_to_load.instantiate()
	current_level.set_name(level_name)
	$CollisionWalls.add_sibling(current_level)
	$HUD.hide_title_screen()
	$HUD.show_message("Starting Game...")
	$StartGameTimer.start()


func pause_game_objects():
	$Ball.pause()
	$Paddle.pause()


func unpause_game_objects():
	$Ball.unpause()
	$Paddle.unpause()
	
	
func mute_or_unmute_sound(muted):
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, muted)
	game_muted = muted
