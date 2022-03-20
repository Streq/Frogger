extends Node2D
export var dive_speed := 1.0
export (float) var time_until_dive := 1.0
export (bool) var dive := false

func _ready():
	for child in get_children():
		child.dive_speed = dive_speed
		child.time_until_dive = time_until_dive
		child.dive = dive
