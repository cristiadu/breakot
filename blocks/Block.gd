extends StaticBody2D
class_name Block

@export var points = 1

var random = RandomNumberGenerator.new()

# Define colors as a constant to prevent accidental modifications
const COLORS = [
    Color(0.6, 1, 0, 1), # neon green
    Color(0.7, 0, 1, 1), # magenta pink
    Color(1, 0.7, 0, 1), # bright yellow
    Color(0.4, 0.2, 1, 1), # violet
    Color(1, 0, 0, 1), # red
    Color(0.9, 0.6, 0, 1), # orange
    Color(0.4, 0.6, 1, 1), # light blue
    Color(0.7, 0.4, 0.4, 1), # light brown
    Color(0, 0, 0.5, 1), # dark blue
    Color(0.4, 0.1, 0.3, 1), # wine color
]

# Define a constant for the block type
const BLOCK_TYPE = "Block"

signal hit

# Called when the node enters the scene tree for the first time
func _ready():
    add_to_group("block")
    apply_color()

# Apply a random color to the block
func apply_color():
    random.randomize()
    $Sprite2D.self_modulate = COLORS[random.randi_range(0, COLORS.size() - 1)]
    
# Called when the block is hit
func on_hit():	
    play_destroy_sound()
    hit.emit(true, points)
    queue_free()

# Play the sound when the block is destroyed
func play_destroy_sound():
    var root_parent = get_node("/root/Main")
    var sound_node_name = "HitSound" + BLOCK_TYPE
    
    if not root_parent.has_node(sound_node_name):
        var new_parent_sound_node = $HitSound.duplicate()
        new_parent_sound_node.name = sound_node_name
        root_parent.add_child(new_parent_sound_node)
        
    var hit_sound_on_parent = root_parent.get_node(sound_node_name)
    hit_sound_on_parent.play()

# Return the block type
func get_block_type():
    return BLOCK_TYPE
