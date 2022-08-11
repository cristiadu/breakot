extends StaticBody2D

export var speed = 300
var screen_limit_left
var screen_limit_right

func _ready():
	screen_limit_left = 0 + $Sprite.texture.get_width() / 4
	screen_limit_right = get_viewport_rect().size.x - $Sprite.texture.get_width() / 4
	hide()
	
	
func _process(delta):
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
		
	var horizontal_movement = direction * speed * delta
	position.x = clamp(position.x + horizontal_movement, screen_limit_left, screen_limit_right)
	

func reset(pos):
	position = pos
	show()
