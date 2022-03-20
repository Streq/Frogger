extends Node2D

export (bool) var flip_to_speed := false setget set_flip_to_speed
export (float)  var speed := 0.0 setget set_speed

func _ready():
	if flip_to_speed and speed<0.0:
		flip_components()
		
	
func set_speed(val):
	if flip_to_speed and (speed<0) != (val<0):
		flip_components()
	speed = val
	
func set_flip_to_speed(val):
	if val != flip_to_speed:
		if speed < 0:
			flip_components()
		flip_to_speed = val
	
func _physics_process(delta):
	position.x += speed*delta


func flip_components():
	for child in get_children():
		if "flip_h" in child:
			child.flip_h = !child.flip_h
		elif "scale" in child:
			child.scale.x = -child.scale.x
