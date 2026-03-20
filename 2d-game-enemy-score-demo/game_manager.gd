extends Node

var score = 0
var score_label: Label

func add_score(amount):
	score += amount
	update_label()

func set_score_label(label: Label):
	score_label = label
	update_label()

func update_label():
	if score_label:
		score_label.text = "Score: " + str(score)
