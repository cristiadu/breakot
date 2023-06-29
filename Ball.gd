extends CharacterBody2D

signal lost_life

@export var initial_speed = 300
@export var speed_increment = 150.0

# max direction used for both X and Y axis.
# Configuring this to smaller numbers reduces the boundaries of the ball's angle after colliding.
var max_direction_value = 0.84

var speed = initial_speed
var ball_paused = true
var direction = Vector2(1, 0).rotated(PI/4)
var screen_limit_left
var screen_limit_right


func _ready():
	screen_limit_left = $Sprite2D.texture.get_width() / 12
	screen_limit_right = get_viewport_rect().size.x - $Sprite2D.texture.get_width() / 12
	var err = $BallSpeedTimer.timeout.connect(increase_ball_speed)
	if err:
		print("Error when creating ball speed timer.")

	ball_paused = true
	hide()


func _physics_process(delta):
	if not ball_paused:
		var obj_velocity = speed * delta * direction
		var collision = move_and_collide(obj_velocity)
		if collision:
			direction = direction.bounce(collision.get_normal())
			direction.x = clamp(direction.x, -max_direction_value, max_direction_value)
			direction.y = clamp(direction.y, -max_direction_value, max_direction_value)
			position.x = clamp(position.x, screen_limit_left, screen_limit_right)
			on_block_collision(collision.get_collider())


func on_block_collision(body):
	if body.is_in_group("block"):
		body.on_hit()
	elif body.name == "BottomWall":
		lost_life.emit()
	elif body.name == "Paddle":
		$BallOnPaddleSound.play()


func reset(pos):
	direction = Vector2(1, 0).rotated(PI/4)
	speed = initial_speed
	position = pos
	
	show()
	ball_paused = false
	$BallSpeedTimer.start()


func pause():
	$BallSpeedTimer.stop()
	ball_paused = true


func increase_ball_speed():
	speed += speed_increment
