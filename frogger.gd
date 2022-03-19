extends Node2D


const STEP_SIZE = Global.TILE_SIZE
onready var tween = $Tween

func _input(event):
	if event.is_action_pressed("ui_up"):
		step(Vector2(0,-1))
	if event.is_action_pressed("ui_down"):
		step(Vector2(0,1))
	if event.is_action_pressed("ui_left"):
		step(Vector2(-1,0))
	if event.is_action_pressed("ui_right"):
		step(Vector2(1,0))

func step(dir):
	position += dir*STEP_SIZE
