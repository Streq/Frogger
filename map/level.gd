extends Node2D

signal complete
signal game_over

onready var spawn_point := $spawn_point
onready var player := $frogger as Frog
onready var time_bar := $time_bar
onready var lives_label := $lives_label
onready var score_value_label := $score_value_label
onready var hiscore_value_label := $hiscore_value_label
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
	lives_label.text = "x%d" % Global.current_lives
	
	player.update_ground()
	player._on_step_landed()

	
func _ready():
	setup_player()

func _process(delta):
	if is_instance_valid(player_timer):
		time_bar.value = player_timer.time_left / player_timer.wait_time * 100
	score_value_label.text = String(Global.current_score).pad_zeros(5)
	hiscore_value_label.text = String(Global.hiscore).pad_zeros(5)

func _physics_process(delta):
	if completed:
		yield(message.timer,"timeout")
		next_level()
	elif goal_completed:
		goal_completed = false
		spawn()

func next_level():
	message.set_message("laso",2)
	pass
	
func _on_frogger_dead(who, why):
	Global.current_lives -= 1
	var frog := who as Frog
	var death_anim := frog.animation as AnimationPlayer
	if why == "timeout":
		message.set_message("TIME OVER", 5.0)
	
	var coso = yield(death_anim, "animation_finished")
	message.set_message("")
	
	
	
	if Global.current_lives<0:
		emit_signal("game_over")
		message.set_message("GAME OVER", 5.0)
		
	else:
		frog.queue_free()
		spawn()
		setup_player()


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
