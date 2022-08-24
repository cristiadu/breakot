extends Block

func _ready():
	add_to_group("unbreakable_block")
	points = 0
	

func apply_color():
	# No color applied to this block.
	pass


func hit():
	$HitSound.play()


func get_block_type():
	return "MetalBlock"
