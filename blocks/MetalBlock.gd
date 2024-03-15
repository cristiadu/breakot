extends Block

# Define constants for the block type and group
const BLOCK_TYPE = "MetalBlock"
const UNBREAKABLE_GROUP = "unbreakable_block"
# Define a constant for the points value
const POINTS_VALUE = 0

# Called when the node enters the scene tree for the first time
func _ready():
    add_to_group(UNBREAKABLE_GROUP)
    points = POINTS_VALUE
    super._ready()

# No color applied to this block
func apply_color():
    pass

# Called when the block is hit
func on_hit():
    $HitSound.play()

# Return the block type
func get_block_type():
    return BLOCK_TYPE
