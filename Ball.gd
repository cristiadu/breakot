extends KinematicBody2D

signal lost_life

export var initial_speed = 300
export var speed_increment = 150.0

var speed = initial_speed
var ball_paused = true
var direction = Vector2(1, 0).rotated(1)


func _ready():
	var err = $BallSpeedTimer.connect("timeout", self, "increase_ball_speed")
	if err:
		print("Error when creating ball speed timer.")

	ball_paused = true
	hide()


func _physics_process(delta):
	if not ball_paused:
		var velocity = speed * delta * direction
		var collision = move_and_collide(velocity)
		if collision:
			direction = direction.bounce(collision.normal)
			on_block_collision(collision.collider)


func on_block_collision(body):
	if body.is_in_group("block"):
		body.hit()
	elif body.name == "BottomWall":
		emit_signal("lost_life")


func reset(pos):
	direction = Vector2(1, 0).rotated(1)
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
