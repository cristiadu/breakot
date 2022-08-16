extends CanvasLayer

signal level_won
signal level_lost

var new_highscore = false
var initial_text = "Press ENTER to start."
var current_points = 0
var highscore = 0
var initial_lives = 3
var lives = initial_lives
var active_blocks_count setget set_blocks_count

var save = File.new()
var save_file = "user://game.save"


func _ready():
	var err = self.connect("tree_exiting", self, "on_HUD_destroy")
	if err:
		print("Error when linking HUD delete behavior")
		
	err = get_node("../Ball").connect("lost_life", self, "on_life_lost")
	if err:
		print("Error when linking life lost behavior")
	
	if not save.file_exists(save_file):
		save_highscore()
	else:
		load_highscore()
	show_message(initial_text, false)


func on_HUD_destroy():
	if new_highscore:
		save_highscore()


func on_life_lost():
	get_node("Lives/Heart" + str(lives) + "/AnimatedSprite").animation = "empty"
	lives-=1
	if(lives <= 0):
		emit_signal("level_lost")


func set_blocks_count(new_count):
	active_blocks_count = new_count
	if active_blocks_count == 0:
		emit_signal("level_won")


func reset():
	current_points = 0
	lives = initial_lives
	
	var blocks = get_tree().get_nodes_in_group("block")
	self.active_blocks_count = blocks.size()
	for block in blocks:
		block.connect("hit", self, "increase_score", [block.points])
		
	for heart in $Lives.get_children():
		heart.get_node("AnimatedSprite").animation = "full"


func hide_title_screen():
	$TitleScreen.visible = false
	$TitleBackground.visible = false


func show_title_screen():
	$TitleScreen.visible = true
	$TitleBackground.visible = true
	show_message(initial_text, false)


func show_message(message, disappear_after_timer = true):
	$InfoMessage.text = message
	$InfoMessage.show()
	if disappear_after_timer:
		yield(get_tree().create_timer(2), "timeout")
		$InfoMessage.hide()


func increase_score(points):
	current_points += points
	self.active_blocks_count -= 1
	$CurrentScore.text = str(current_points)
	
	if highscore < current_points:
		set_highscore(current_points)


func set_highscore(score):
	highscore = score
	new_highscore = true
	$Highscore.text = str(highscore)


func load_highscore():
	save.open(save_file, File.READ)
	var save_data = save.get_var()
	save.close()
	set_highscore(save_data["highscore"])
	

func save_highscore():
	save.open(save_file, File.WRITE)
	var save_data = { "highscore": highscore }
	save.store_var(save_data)
	save.close()
