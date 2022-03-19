extends Node2D

export var speed := 0.0

func _physics_process(delta):
	position.x += speed*delta
