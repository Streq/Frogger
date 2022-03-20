extends Node2D

signal dead()

export var lives = 2
const STEP_SIZE = Global.TILE_SIZE
const STEP_SPEED = 0.15


onready var tween = $Tween
onready var step_sound = $step_sound
onready var sprite = $Sprite
onready var animation = $animation
onready var ground_detect = $ground_detect

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

func _ready():
	tween.connect("tween_all_completed", self, "_on_step_landed")
	pass
func _input(event):
	for dir in dirs.values():
		dir.input(event)


func _physics_process(delta):
	if !dead:
		move()
		if should_die:
			die()
			animation.play("death")
		elif should_drown:
			die()
			animation.play("drown")
	
func die():
	dead = true
	tween.stop_all()
	emit_signal("dead")
	
func move():
	for dir in dirs:
		var d := dirs[dir] as Dir
		if d.pressed:
			if !tween.is_active():
				var vp = get_viewport_rect()
				var target_global_pos = global_position + d.vec*STEP_SIZE
				print(vp, ", ",target_global_pos,", ",global_position)
				
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



func _on_hurtbox_area_entered(area):
	should_die = true

func _on_ground_detect_area_entered(area):
	should_drown = false
func _on_ground_detect_area_exited(area):
	if can_drown and ground_detect.get_overlapping_areas().size() == 0:
		should_drown = true
		reparent(get_tree().root)

func _on_step_landed():
	var grounds = ground_detect.get_overlapping_areas()
	if grounds.size() > 0: 
		var ground = grounds[0]
		if ground != get_parent():
			can_drown = false
			#change ground we're standing on
			reparent(ground)
			can_drown = true


func reparent(new_parent):
	var aux_pos = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = aux_pos
