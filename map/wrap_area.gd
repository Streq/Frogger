extends Area2D

onready var WRAP_WIDTH = get_viewport_rect().size.x+Global.TILE_SIZE*2

func _ready():
	pass # Replace with function body.


func _on_wrap_area_area_exited(area):
	while area.global_position.x < -Global.TILE_SIZE:
		area.global_position.x = area.global_position.x + WRAP_WIDTH
	while area.global_position.x > WRAP_WIDTH-Global.TILE_SIZE:
		area.global_position.x = area.global_position.x - WRAP_WIDTH
	
