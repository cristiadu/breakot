extends Node2D

func _ready():
	start_level(1)


func start_level(level_number):
	# Load new level scene dinamically
	$CurrentLevel.queue_free()
	var level_to_load = load("res://levels/Level" + str(level_number) + ".tscn")
	var current_level = level_to_load.instance()
	current_level.set_name("CurrentLevel")
	add_child(current_level)
	
	$Ball.start($CurrentLevel/StartingBallPosition.position)
	$Paddle.start($CurrentLevel/StartingPaddlePosition.position)
	
	var blocks = get_tree().get_nodes_in_group("block")  
	for block in blocks:  
		block.connect("hit", $HUD, "increase_score", [block.points])
