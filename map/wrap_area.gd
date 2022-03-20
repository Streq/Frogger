extends Area2D

onready var shape := $CollisionShape2D
onready var boundaries := Rect2(shape.global_position-shape.shape.extents, shape.shape.extents*2)
func _ready():
	pass # Replace with function body.


func _on_wrap_area_area_exited(area):
	while area.global_position.x < boundaries.position.x:
		area.global_position.x = area.global_position.x + boundaries.size.x
	while area.global_position.x > boundaries.end.x:
		area.global_position.x = area.global_position.x - boundaries.size.x
	
