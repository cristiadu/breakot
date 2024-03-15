extends CharacterBody2D

# Constants for input direction
const LEFT = -1
const RIGHT = 1
const NO_MOVEMENT = 0

@export var speed = 500
var paddle_paused = false
var screen_limit_left
var screen_limit_right

# Called when the node enters the scene tree for the first time
func _ready():
    calculate_screen_limits()
    hide()

# Calculate the screen limits based on the sprite's width
func calculate_screen_limits():
    screen_limit_left = $Sprite2D.texture.get_width() / 4
    screen_limit_right = get_viewport_rect().size.x - $Sprite2D.texture.get_width() / 4

func _physics_process(delta):
    if not paddle_paused:
        var direction = get_input_direction()
        var horizontal_movement = direction * speed * delta
        position.x = clamp(position.x + horizontal_movement, screen_limit_left, screen_limit_right)

# Get the input direction based on the pressed keys
func get_input_direction():
    match true:
        Input.is_action_pressed("ui_left"):
            return LEFT
        Input.is_action_pressed("ui_right"):
            return RIGHT
        _:
            return NO_MOVEMENT

# Reset the paddle's position and show it
func reset(pos):
    position = pos
    show()
    paddle_paused = false

# Pause the paddle's movement
func pause():
    paddle_paused = true
    
# Unpause the paddle's movement
func unpause():
    paddle_paused = false