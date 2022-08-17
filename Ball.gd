extends KinematicBody2D

signal lost_life

export var speed = 300.0
var ball_paused = true
var velocity = Vector2(speed, 0).rotated(1)


func _ready():
	ball_paused = true
	hide()


func _physics_process(delta):
	if not ball_paused:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			on_block_collision(collision.collider)


func on_block_collision(body):
	if body.is_in_group("block"):
		body.hit()
	elif body.name == "BottomWall":
		emit_signal("lost_life")


func reset(pos):
	velocity = Vector2(speed, 0).rotated(1)
	position = pos
	show()
	ball_paused = false


func pause():
	ball_paused = true
