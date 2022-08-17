extends StaticBody2D
class_name Block

export var points = 1

var random = RandomNumberGenerator.new()

signal hit

func _ready():
	random.randomize()
	add_to_group("block")
	apply_color()


func apply_color():
	var r = random.randf_range(0, 1)
	var g = random.randf_range(0, 1)
	var b = random.randf_range(0, 1)
	$Sprite.self_modulate = Color(r, g, b, 1)
	
	
func hit():
	emit_signal("hit", true, points)
	self.queue_free()
