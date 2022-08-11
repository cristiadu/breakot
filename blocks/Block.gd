extends StaticBody2D
class_name Block

export var points = 1

signal hit

func _ready():
	self.connect("hit", self, "on_Block_hit")
	add_to_group("block")
	# apply color here
	
	
func on_Block_hit():
	self.queue_free()
