extends Node2D

export (bool) onready var flip_h := false setget set_flip_h
export (bool) onready var flip_v := false setget set_flip_v

func set_flip_h(val:bool):
	if val != flip_h:
		flip_h = val
		for child in get_children():
			child.position.x = -child.position.x
			if "flip_h" in child:
				child.flip_h = !child.flip_h
			elif "scale" in child:
				child.scale.x = -child.scale.x

func set_flip_v(val:bool):
	if val != flip_v:
		flip_v = val
		for child in get_children():
			child.position.y = -child.position.y
			if "flip_v" in child:
				child.flip_v = !child.flip_v
			elif "scale" in child:
				child.scale.y = -child.scale.y
