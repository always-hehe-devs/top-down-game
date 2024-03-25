extends BaseMob

enum MOB_STATE {IDLE, FOLLOWING, AIMING, DEAD }

var current_state = MOB_STATE.IDLE

func _physics_process(delta):
	
	match current_state:
		MOB_STATE.AIMING:
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				current_state = MOB_STATE.FOLLOWING
		MOB_STATE.FOLLOWING:
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

func make_path():
	if not get_node_or_null("rotated"):
		var ray := RayCast2D.new()
		ray.name = 'rotated'
		add_child(ray)
	else:
		var ray = get_node('rotated')
		var vector_to_target = to_local(target.global_position).rotated(PI/2)

		ray.target_position = vector_to_target

		navigation_agent.set_target_position(to_global(vector_to_target))
	
func on_body_entered(_body):
	current_state = MOB_STATE.AIMING

func on_body_exited(_body):
	current_state = MOB_STATE.IDLE

func knock_back(source_position):
	knock_back_time = 1
	pushback_force = -global_position.direction_to(source_position) * 3000
