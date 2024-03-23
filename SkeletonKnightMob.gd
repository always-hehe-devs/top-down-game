extends BaseMob

enum MOB_STATE {IDLE, FOLLOWING, AIMING, DEAD }

var current_state = MOB_STATE.IDLE

@onready var hitbox := $HitBox 

func _ready():
	hitbox.set_disabled(true)

func _physics_process(_delta):
	
	match current_state:
		MOB_STATE.AIMING:
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				current_state = MOB_STATE.FOLLOWING
		MOB_STATE.FOLLOWING:
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				move()
				attack()
			else:
				current_state = MOB_STATE.AIMING
	
func attack():
	hitbox.set_disabled(false)
	
func move():
	rotate_sprite()
	make_path()
	var next_path_position := navigation_agent.get_next_path_position()

	var dir = global_position.direction_to(next_path_position)
	var intented_velocity = dir  * speed
	navigation_agent.velocity = intented_velocity
	move_and_slide()

func on_body_entered(_body):
	current_state = MOB_STATE.AIMING

func on_body_exited(_body):
	current_state = MOB_STATE.IDLE
