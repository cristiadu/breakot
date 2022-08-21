extends StaticBody2D
class_name Block

export var points = 1

var random = RandomNumberGenerator.new()
var colors = [
	Color(1, 0, 0.5, 1),
	Color(1, 0, 0, 1),
	Color(0, 1, 0, 1),
	Color(0, 0.25, 1, 1),
	Color(1, 1, 0, 1),
	Color(0, 1, 1, 1),
	Color(1, 0, 1, 1),
	Color(0.5, 0, 1, 1),
	Color(0.5, 0.5, 1, 1),
]

signal hit

func _ready():
	random.randomize()
	add_to_group("block")
	apply_color()


func apply_color():
	$Sprite.self_modulate = colors[random.randi_range(0, colors.size() - 1)]
	
	
func hit():
	emit_signal("hit", true, points)
	self.queue_free()
