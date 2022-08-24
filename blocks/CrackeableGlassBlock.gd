extends Block


func _ready():
	$Sprite.animation = "intact"
	points = 3


func hit():
	if $Sprite.animation == "intact":
		$Sprite.animation = "cracked"
		emit_signal("hit", false, points)
		$CrackSound.play()
	else:
		.hit()


func get_block_type():
	return "CrackeableGlassBlock"
