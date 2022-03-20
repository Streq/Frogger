extends Node2D

signal goal()

onready var goal_area = $goal_area
onready var kill_zone = $kill_zone
onready var sprite = $sprite_full

func _on_goal_zone_area_entered(area):
	call_deferred("goal_completed", area.owner)

func goal_completed(player):
	player.queue_free()
	goal_area.monitoring = false
	goal_area.monitorable = true
	kill_zone.monitorable = true
	sprite.visible = true
	emit_signal("goal")
	
