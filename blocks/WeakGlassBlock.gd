extends Block

func _ready():
	points = 4
	super._ready()


func get_block_type():
	return "WeakGlassBlock"
