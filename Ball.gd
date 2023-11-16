extends CharacterBody2D

signal lost_life

@export var initial_speed = 225.0
@export var speed_increment = 25.0
@export var speed_increment_interval = 6.0

var speed: float = initial_speed
var ball_paused: bool = true
var direction = Vector2(1, 0).rotated(PI/4)


func _ready():
	$BallSpeedTimer.wait_time = speed_increment_interval
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
			# If paddle is moving, then ball direction is changed based on it.
			if collision.get_collider_velocity() != Vector2.ZERO:
				var temp_direction = direction + collision.get_collider_velocity()
				direction.x = temp_direction.normalized().x
			
			var new_direction = direction.bounce(collision.get_normal())
			if(!new_direction.is_normalized()):
				direction = new_direction.normalized()
			else:
				direction = new_direction
				
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
	
	
func unpause():
	$BallSpeedTimer.start()
	ball_paused = false


func increase_ball_speed():
	speed += speed_increment
