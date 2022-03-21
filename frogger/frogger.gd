extends Node2D
class_name Frog
signal dead(who, why)

export var lives = 2
var STEP_SIZE = Global.TILE_SIZE
const STEP_SPEED = 0.15


onready var tween := $Tween as Tween
onready var step_sound = $step_sound
onready var sprite = $Sprite
onready var animation = $animation
onready var ground_detect := $ground_detect as Area2D
onready var death_timer = $death_timer

onready var dirs = {
	"down": Dir.new("down", Vector2.DOWN),
	"up": Dir.new("up", Vector2.UP),
	"right": Dir.new("right", Vector2.RIGHT),
	"left": Dir.new("left", Vector2.LEFT)
}


var current_dir = "up"
var dead = false
var should_drown = false
var should_die = false
var can_drown = true
var timeout = false
onready var record_y = global_position.y

func _ready():
	tween.connect("tween_all_completed", self, "_on_step_landed")
	pass
func _input(event):
	for dir in dirs.values():
		dir.input(event)

var current_ground = null
func query_ground():
	var space_rid := get_world_2d().space
	var space_state := Physics2DServer.space_get_direct_state(space_rid)
	var params := Physics2DShapeQueryParameters.new()
	params.collision_layer = ground_detect.collision_mask
	var col_shape = ground_detect.get_node("CollisionShape2D")
	params.set_shape(col_shape.shape)
	params.transform = col_shape.global_transform
	params.collide_with_areas = true
	params.collide_with_bodies = false
	
	var grounds = space_state.intersect_shape(params)
	for entry in grounds:
		var ground = entry.collider as Area2D
		return ground
	return null
func update_ground():
	var on_ground = false
	current_ground = query_ground()
	if current_ground:
#		print_debug(current_ground)
		on_ground = true
	else:
#		print_debug("no ground")
		should_drown = true
		if get_parent() != get_tree().root:
			reparent(get_tree().root)

func _physics_process(delta):
	if !dead:
		move()
		update_ground()
#		print_debug("reparent_called:", rep)
		rep = 0
		
		
		if should_die:
			die("squash")
			animation.play("death")
		elif should_drown:
			die("drown")
			animation.play("drown")
		elif timeout:
			die("timeout")
			animation.play("death")
	
func die(cause):
	dead = true
	tween.remove_all()
	emit_signal("dead", self, cause)
	death_timer.paused = true


func move():
	for dir in dirs:
		var d := dirs[dir] as Dir
		if d.pressed:
			if !tween.is_active():
				var vp = get_viewport_rect()
				var target_global_pos = global_position + d.vec*STEP_SIZE
				print_debug(vp, ", ",target_global_pos,", ",global_position)
				
				if vp.has_point(global_position) and vp.has_point(target_global_pos):
					step_sound.play()
					if d.vec.y:
						tween.interpolate_property(self, "global_position", null, global_position + d.vec*STEP_SIZE, STEP_SPEED)
					else:
						tween.interpolate_property(self, "position", null, position + d.vec*STEP_SIZE, STEP_SPEED)
					
					tween.start()
					animation.play(d.jump_anim,-1, 1.0/STEP_SPEED)
					d.pressed = false
					current_dir = dir
					return
	if !animation.is_playing():
		animation.play(dirs[current_dir].idle_anim,-1, 0.25/STEP_SPEED)
		
class Dir:
	var pressed := false
	var event_name := "ui_"
	var jump_anim := "jump_"
	var idle_anim := "idle_"
	var vec := Vector2()
	
	func _init(name, dir):
		event_name = "ui_"+name
		jump_anim = "jump_"+name
		idle_anim = "idle_"+name
		vec = dir
	func input(event):
		if event.is_action_pressed(event_name):
			pressed = true
		elif event.is_action_released(event_name):
			pressed = false



var rep = 0
func reparent(new_parent):
	rep += 1
	call_deferred("_reparent", new_parent)
func _reparent(new_parent):
	var aux_pos = global_position
	tween.stop_all()
	var old_parent = get_parent()
	if is_instance_valid(old_parent):
		old_parent.remove_child(self)
	new_parent.add_child(self)
	tween.resume_all()
	global_position = aux_pos
	
func _on_death_timer_timeout():
	timeout = true
	
func _on_step_landed():
	if global_position.y < record_y:
		record_y = global_position.y
		Global.current_score+=10
	if current_ground and current_ground != get_parent():
		reparent(current_ground)

func _on_hurtbox_area_entered(area):
	   should_die = true
