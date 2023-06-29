extends Block


func _ready():
	$Sprite2D.animation = "intact"
	points = 3


func on_hit():
	if $Sprite2D.animation == "intact":
		$Sprite2D.animation = "cracked"
		hit.emit(false, points)
		$CrackSound.play()
	else:
		super.on_hit()


func get_block_type():
	return "CrackeableGlassBlock"
