extends CanvasLayer

var current_points = 0
var highscore = 0
var new_highscore = false
var initial_text = "Press ENTER to start."

var save = File.new()
var save_file = "user://game.save"


func _ready():
	self.connect("tree_exiting", self, "_on_HUD_destroy")
	if not save.file_exists(save_file):
		save_highscore()
	else:
		load_highscore()
		
	$InfoMessage.text = initial_text


func _on_HUD_destroy():
	if new_highscore:
		save_highscore()


func reset():
	current_points = 0
	$InfoMessage.hide()
	
	var blocks = get_tree().get_nodes_in_group("block")  
	for block in blocks:
		block.connect("hit", self, "increase_score", [block.points])


func show_message(message):
	$InfoMessage.text = message
	$InfoMessage.show()
	yield(get_tree().create_timer(10), "timeout")
	$InfoMessage.hide()


func increase_score(points):
	current_points += points
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
	print(save_data)
	save.close()
	set_highscore(save_data["highscore"])
	

func save_highscore():
	save.open(save_file, File.WRITE)
	var save_data = { "highscore": highscore }
	save.store_var(save_data)
	save.close()
