extends Block

# Define constants for the block type and animations
const BLOCK_TYPE = "CrackeableGlassBlock"
const INTACT_ANIMATION = "intact"
const CRACKED_ANIMATION = "cracked"
# Define a constant for the points value
const POINTS_VALUE = 3

# Called when the node enters the scene tree for the first time
func _ready():
    $Sprite2D.animation = INTACT_ANIMATION
    points = POINTS_VALUE
    super._ready()

# Called when the block is hit
func on_hit():
    if $Sprite2D.animation == INTACT_ANIMATION:
        $Sprite2D.animation = CRACKED_ANIMATION
        hit.emit(false, points)
        $CrackSound.play()
    else:
        super.on_hit()

# Return the block type
func get_block_type():
    return BLOCK_TYPE
