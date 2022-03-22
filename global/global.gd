extends CanvasLayer

signal life_up

export var PLAYER : PackedScene
export var MAIN_MENU : PackedScene

export (Array, PackedScene) var levels

const TILE_SIZE := 16
const LIVES := 2
const SCORE_1UP = 20000

var current_lives = LIVES
var current_level = 0
var current_score = 0 setget set_current_score
var hiscore = 0
var lives_score = 1

func set_current_score(val):
	while val >= lives_score * SCORE_1UP:
		current_lives += 1
		lives_score += 1
		emit_signal("life_up")
	current_score = val
	if current_score >= hiscore:
		hiscore = current_score
	update_score()

func game_over():
	get_tree().change_scene_to(MAIN_MENU)

func new_game():
	current_score = 0
	current_level = 0
	current_lives = LIVES
	go_to_level(current_level)

func next_level():
	current_level += 1
	var actual_level = current_level
	if current_level >= levels.size():
		actual_level = levels.size()-1 - ((current_level % levels.size()) % 2)
	go_to_level(actual_level)

func go_to_level(level):
	get_tree().change_scene_to(levels[level])
	update_level()

func update_score():
	$hiscore_value_label.text = String(hiscore).pad_zeros(5)
	$score_value_label.text = String(current_score).pad_zeros(5)

func update_level():
	$level_value_label.text = String(current_level + 1)

func _input(event):
	if event.is_action_pressed("ui_select") and OS.is_debug_build():
		next_level()
