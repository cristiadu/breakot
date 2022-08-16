extends RigidBody2D

signal lost_life

export var speed = 300.0
var reset_ball = false
var initial_pos

func _ready():
	var err = self.connect("body_entered", self, "check_block_collision")
	if err:
		print("Error when linking block collision behavior")
	
	hide()


func _integrate_forces(state):
	if reset_ball:
		# Cannot change positions of RigidBody2D directly
		# it has to be through this method or through applied physical forces.
		state.transform = Transform2D(0, initial_pos)
		reset_ball = false
		apply_impulse(Vector2(), Vector2(1, 1).normalized() * speed)
		show()


func reset(pos):
	initial_pos = pos
	self.sleeping = false
	reset_ball = true


func check_block_collision(body):
	if body.is_in_group("block"):
		body.hit()
	elif body.name == "BottomWall":
		emit_signal("lost_life")
