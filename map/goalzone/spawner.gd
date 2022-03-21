extends Node
class_name GoalSpawner

export var spawn_time = 5.0
onready var timer = $Timer


func _ready():
	timer.wait_time = spawn_time
	timer.start()
	timer.connect("timeout", self, "spawn")

func spawn():
	var goalzone = owner.get_parent()
	var goals := goalzone.goals.get_children() as Array
#	var availables := []
#	for goal in goals:
#		if !goal.full:
#			availables.push_back(goal)
#	owner.global_position = availables[randi()%availables.size()].global_position
#	owner.appear()
	var goal = goals[randi()%goals.size()]
	if !goal.full:
		owner.global_position = goal.global_position
		owner.appear()

