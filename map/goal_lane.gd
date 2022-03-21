extends TileMap

signal level_completed
signal goal


var goals_completed = 0


onready var goals = $goals

func _ready():
	for goal in goals.get_children():
		goal.connect("goal", self, "_on_goal") 

func _on_goal():
	goals_completed += 1
	emit_signal("goal")
	
	if goals_completed == goals.get_children().size():
		emit_signal("level_completed")
