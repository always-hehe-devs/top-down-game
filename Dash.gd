extends Node2D
class_name Dash

@onready var timer = $DashTimer
@onready var current_scene = get_tree().get_current_scene()

var dash_ghost_scene = preload("res://DashGhost.tscn")
var speed = 300
var time = 0
const TIME_PERIOD = 0.05

func _ready():
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = 0.2
	timer.timeout.connect(end_dash)
	
func _process(delta):
	if is_dashing():
		time +=delta
		if time > TIME_PERIOD:
			time = 0
			instance_dash_ghost()
	
func start_dash():
	if not is_dashing():
		timer.start()
		instance_dash_ghost()

func instance_dash_ghost():
	var dash_ghost = dash_ghost_scene.instantiate()

	dash_ghost.global_position = global_position
	current_scene.add_child(dash_ghost)
	
func end_dash():
	timer.stop()

func is_dashing():
	return !timer.is_stopped()
	
