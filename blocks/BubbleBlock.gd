extends Block

func _ready():
	points = 5
	super._ready()


func get_block_type():
	return "BubbleBlock"
