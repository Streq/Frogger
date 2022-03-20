extends Area2D

onready var dive_timer = $dive_timer
onready var animation = $AnimationPlayer

export var dive_speed := 1.0
export (float) var time_until_dive := 1.0 setget set_time_until_dive
export (bool) var dive := false setget set_dive

func _ready():
	update_dive_timer()


func _on_dive_timer_timeout():
	animation.play("dive", -1.0, dive_speed)
	yield(animation, "animation_finished")
	dive_timer.start()
	animation.play("idle")
	
func set_time_until_dive(seconds):
	dive_timer.wait_time = seconds

func set_dive(val):
	if val != dive:
		dive = val
		if is_instance_valid(dive_timer):
			update_dive_timer()
func update_dive_timer():
	if dive:
		dive_timer.start()
	else:
		dive_timer.stop()
