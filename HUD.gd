extends CanvasLayer

signal level_won
signal level_lost

var new_highscore = false
var initial_text = "Press ENTER to start."
var current_points = 0
var highscore = 0
var initial_lives = 3
var lives = initial_lives
var active_blocks_count : set = on_blocks_count_setter

var save_file = "user://game.save"

func _ready():
	var err = self.tree_exiting.connect(on_HUD_destroy)
	if err:
		print("Error when linking HUD delete behavior")
		
	err = $HideHUDMessageTimer.timeout.connect(on_timeout_hide_message)
	if err:
		print("Error when linking HUD delete behavior")
		
	if not FileAccess.file_exists(save_file):
		save_highscore()
	else:
		load_highscore()
	show_message(initial_text, false)


func _process(_delta):
	# If title screen is being shown, then background sound should play.
	if $TitleBackground.visible and not $TitleBackgroundSound.playing:
		$TitleBackgroundSound.play()


func on_HUD_destroy():
	if new_highscore:
		save_highscore()


func life_lost():
	get_node("Lives/Heart" + str(lives) + "/AnimatedSprite2D").animation = "empty"
	lives-=1
	if lives == 0:
		level_lost.emit()


func on_blocks_count_setter(new_count):
	active_blocks_count = new_count
	if active_blocks_count == 0:
		level_won.emit()


func reset():
	lives = initial_lives
	
	var blocks = get_tree().get_nodes_in_group("block")
	self.active_blocks_count = blocks.size()
	for block in blocks:
		if block.is_in_group("unbreakable_block"):
			self.active_blocks_count -= 1

		block.hit.connect(increase_score)
		
	for heart in $Lives.get_children():
		heart.get_node("AnimatedSprite2D").animation = "full"


func hide_title_screen():
	$TitleScreen.visible = false
	$TitleBackground.visible = false
	$TitleBackgroundSound.stop()


func show_title_screen():
	current_points = 0
	$HideHUDMessageTimer.stop()
	$CurrentScore.text = str(current_points)
	$TitleScreen.visible = true
	$TitleBackground.visible = true
	show_message(initial_text, false)


func show_message(message, disappear_after_timer = true):
	$InfoMessage.text = message
	$InfoMessage.show()
	if disappear_after_timer:
		$HideHUDMessageTimer.start()


func on_timeout_hide_message():
	$InfoMessage.hide()


func increase_score(block_destroyed, points):
	current_points += points
	$CurrentScore.text = str(current_points)
	
	if block_destroyed:
		self.active_blocks_count -= 1
	
	if highscore < current_points:
		# When entered here for the first time for current level.
		# So sound doesn't keep playing on each new score after having a new highscore.
		if not new_highscore:
			await $NewHighscoreSound.play()
		set_highscore(current_points)


func set_highscore(score):	
	highscore = score
	new_highscore = true
	$Highscore.text = str(highscore)


func load_highscore():
	var save = FileAccess.open(save_file, FileAccess.READ)
	var save_data = save.get_var()
	set_highscore(save_data["highscore"])
	save.close()

func save_highscore():
	var save = FileAccess.open(save_file, FileAccess.WRITE)
	var save_data = { "highscore": highscore }
	save.store_var(save_data)
	save.close()
