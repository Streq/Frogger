extends Area2D


var croc_on_the_scene = false
var croc_steps = 0
var spawn_a_croc = false

export (float) var odds := 1.0
onready var croc = preload("res://entities/float/croc/croc.tscn").instance()
onready var croc_parts = croc.get_children()

var log_parts = []
var despawning_croc = false
var despawning_log = false
func _ready():
	for part in croc_parts:
		part.get_parent().remove_child(part)

func _on_log_detector_area_entered(area:Area2D):
	if area.is_in_group("croc"):
		if croc_on_the_scene and (area == croc_parts[0] or despawning_croc):
			despawning_croc = true
			var log_part = log_parts.pop_front()
			replace(area, log_part)
			croc_steps += 1
	else:
		if !croc_on_the_scene and (area.is_in_group("log_tip") or despawning_log):
			if !despawning_log:
				spawn_a_croc = randf() < odds
			if spawn_a_croc:
				var croc_part = croc_parts[croc_steps]
				replace(area, croc_part)
				log_parts.push_back(area)
			despawning_log = true
			croc_steps += 1
	if croc_steps == croc_parts.size():
		croc_steps = 0
		croc_on_the_scene = is_instance_valid(croc_parts[0].get_parent())
		despawning_croc = false
		despawning_log = false
	
func replace(node, with):
	var t = node.global_transform
	var p = node.get_parent()
	p.remove_child(node)
	p.add_child(with)
	with.global_transform = t
