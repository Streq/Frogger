extends Node2D

onready var label = $Label
onready var timer = $Timer

func set_message(message, time = -1.0):
	label.text = message
	timer.start(time)

func _on_Timer_timeout():
	label.text = ""
	
