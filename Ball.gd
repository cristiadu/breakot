extends RigidBody2D

export var speed = 300.0

func _ready():
	self.connect("body_entered", self, "check_block_collision")
	hide()


func start(pos):
	position = pos
	apply_impulse(Vector2(), Vector2(1, 1).normalized() * speed)
	show()


func check_block_collision(body):
	if body.is_in_group("block"):
		body.emit_signal("hit")
