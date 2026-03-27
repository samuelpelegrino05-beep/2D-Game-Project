extends Node

var score = 0
var player_health = 3
var max_health = 3

var score_label: Label
var health_label: Label

var visited = []
var key_found = []
var opened_doors = []

# ----- Score -----
func add_score(amount):
	score += amount
	update_score_label()
	
func subtract_score(amount):
	score -= amount
	update_score_label()

func set_score_label(label: Label):
	score_label = label
	update_score_label()

func update_score_label():
	if score_label:
		score_label.text = "Score: " + str(score)

# ----- Health -----
func set_health_label(label: Label):
	health_label = label
	update_health_label()

func change_health(amount):
	player_health = clamp(player_health + amount, 0, max_health)
	update_health_label()

func update_health_label():
	if health_label:
		health_label.text = "Health: " + str(player_health)
