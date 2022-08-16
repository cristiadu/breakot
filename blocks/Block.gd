extends StaticBody2D
class_name Block

export var points = 1

signal hit

func _ready():
	add_to_group("block")
	# apply color here
	
	
func hit():
	emit_signal("hit")
	self.queue_free()
