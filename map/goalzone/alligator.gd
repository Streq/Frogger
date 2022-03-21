extends Node2D

onready var animation = $AnimationPlayer
onready var shape = $hitbox/CollisionShape2D

func _ready():
	disappear()

func appear():
	animation.play("appear")


func _on_animation_finished(anim_name):
	disappear()

func disappear():
	disable_shape(true)
	visible = false

func disable_shape(val):
	shape.set_deferred("disabled",val)
