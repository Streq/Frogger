extends Timer

export var new_speed := 0.0 

func trigger():
	get_parent().speed = new_speed
