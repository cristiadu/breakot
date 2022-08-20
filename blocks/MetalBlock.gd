extends Block

func _ready():
	add_to_group("unbreakable_block")
	points = 0
	

func apply_color():
	# No color applied to this block.
	pass


func hit():
	# Do nothing as it's unbreakable.
	pass
