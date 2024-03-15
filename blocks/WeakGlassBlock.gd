extends Block

# Define a constant for the block type
const BLOCK_TYPE = "WeakGlassBlock"
# Define a constant for the points value
const POINTS_VALUE = 4

# Called when the node enters the scene tree for the first time
func _ready():
    points = POINTS_VALUE
    super._ready()

# Return the block type
func get_block_type():
    return BLOCK_TYPE