extends Node2D

onready var timer = $Timer
onready var shape = $hitbox/CollisionShape2D
export var lifespan = 3.0

func _ready():
	disappear()


func _on_hitbox_area_entered(area):
	Global.current_score += 200
	disappear()
	
func appear():
	call_deferred("appear_deferred")
func appear_deferred():
	timer.start(lifespan)
	visible = true
	shape.disabled = false


func disappear():
	call_deferred("disappear_deferred")
func disappear_deferred():
	visible = false
	shape.disabled = true
