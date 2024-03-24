extends "res://BaseMob.gd"

@onready var spell_timer = $Timer
const PortalScene: PackedScene = preload("res://Portal.tscn")

enum MOB_STATE {IDLE, FOLLOWING, AIMING, DEAD }

var current_state = MOB_STATE.IDLE

func _physics_process(delta):
	
	match current_state:
		MOB_STATE.IDLE:
			spell_timer.stop()
		MOB_STATE.AIMING:
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				current_state = MOB_STATE.FOLLOWING
		MOB_STATE.FOLLOWING:
			if spell_timer.is_stopped():
				spell_timer.start()
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				move(delta)
			else:
				current_state = MOB_STATE.AIMING

func move(delta):
	rotate_sprite()
	make_path()
	var next_path_position := navigation_agent.get_next_path_position()

	var dir = global_position.direction_to(next_path_position)
	var intented_velocity = dir  * speed
	navigation_agent.velocity = intented_velocity
	
	handle_knockback(delta)
	move_and_slide()

func throw_spell():
	var spell = PortalScene.instantiate()
	spell.position = player.position
	add_child(spell)

func knock_back(source_position):
	knock_back_time = 1
	pushback_force = -global_position.direction_to(source_position) * 3000
	
func _on_timer_timeout():
	if current_state == MOB_STATE.FOLLOWING:
		throw_spell()

func on_body_entered(_body):
	current_state = MOB_STATE.AIMING

func on_body_exited(_body):
	current_state = MOB_STATE.IDLE
