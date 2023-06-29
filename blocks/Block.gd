extends StaticBody2D
class_name Block

@export var points = 1

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
	add_to_group("block")
	apply_color()


func apply_color():
	random.randomize()
	$Sprite2D.self_modulate = colors[random.randi_range(0, colors.size() - 1)]
	
	
func on_hit():	
	play_destroy_sound()
	hit.emit(true, points)
	queue_free()


func play_destroy_sound():
	# We add into the Main scene so the "queue_free" is not delayed due to the sound playing.
	var root_parent = get_node("/root/Main")
	var sound_node_name = "HitSound" + get_block_type()
	
	if not root_parent.has_node(sound_node_name):
		var new_parent_sound_node = $HitSound.duplicate()
		new_parent_sound_node.name = sound_node_name
		root_parent.add_child(new_parent_sound_node)
		
	var hit_sound_on_parent = root_parent.get_node(sound_node_name)
	hit_sound_on_parent.play()


func get_block_type():
	return "Block"
