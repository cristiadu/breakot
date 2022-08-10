extends CanvasLayer

var current_points = 0
var highscore = 0


func increase_score(points):
	current_points += points
	$CurrentScore.text = str(current_points)
	print(current_points)
