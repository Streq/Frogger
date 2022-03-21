extends Node2D

signal complete
signal game_over

onready var spawn_point := $spawn_point
onready var player := $frogger as Frog
onready var time_bar := $time_bar
onready var lives_label := $lives_label
onready var message = $message


export (Color) var low_time_color = Color(0xe7002fff)
export (Color) var high_time_color = Color(0xb8a401ff)

var player_timer : Timer = null
var goal_completed = false
var completed = false

func spawn():
	var new_player = Global.PLAYER.instance() as Frog
	add_child(new_player)
	new_player.global_position = spawn_point.global_position
	player = new_player
	setup_player()

func setup_player():
	player.connect("dead", self, "_on_frogger_dead", [], CONNECT_DEFERRED)
	player_timer = player.death_timer as Timer
	
	player.record_y = player.global_position.y
	update_lives_display()
	
	player.update_ground()
	player._on_step_landed()
	
	player.level = self

func update_lives_display():
	lives_label.text = "x%d" % Global.current_lives

func _ready():
	Global.connect("life_up", self, "update_lives_display")
	setup_player()

func _process(delta):
	if is_instance_valid(player_timer):
		time_bar.value = player_timer.time_left / player_timer.wait_time * 100
func _physics_process(delta):
	if completed:
		pass
	elif goal_completed:
		goal_completed = false
		spawn()

	
func _on_frogger_dead(who, why):
	Global.current_lives -= 1
	var frog := who as Frog
	var death_anim := frog.animation as AnimationPlayer
	if why == "timeout":
		message.set_message("TIME OVER", 5.0)
	
	yield(death_anim, "animation_finished")
	message.set_message("")
	
	if Global.current_lives<0:
		message.set_message("GAME OVER", 2.0)
		message.timer.connect("timeout", Global, "game_over", [], CONNECT_ONESHOT)
	else:
		frog.queue_free()
		spawn()


func _on_time_bar_value_changed(value):
	if value < 20:
		time_bar.tint_progress = Color(0xe7002fff)
	else:
		time_bar.tint_progress = Color(0xb8a401ff)
	

func _on_goalzone_goal():
	goal_completed = true
	var time_points := int(player_timer.time_left)*2
	var time := str(time_points).pad_zeros(2)
	message.set_message("TIME "+time)
	Global.current_score += 50 + time_points * 10

func _on_goalzone_level_completed():
	completed = true
	yield(message.timer,"timeout")
	Global.next_level()
