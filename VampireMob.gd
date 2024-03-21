extends Enemy

var speed = 40

@onready var animation = $AnimatedSprite2D
@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D
@onready var spell_timer = $Timer
const PortalScene: PackedScene = preload("res://Portal.tscn")

var health = 100
var is_following = false

enum MOB_STATE {IDLE, FOLLOWING, AIMING }

var target = null

var current_state = MOB_STATE.IDLE

func _physics_process(_delta):
	
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
				move()
			else:
				current_state = MOB_STATE.AIMING

func move():
	rotate_sprite()
	make_path()
	var next_path_position := navigation_agent.get_next_path_position()

	var dir = global_position.direction_to(next_path_position)
	var intented_velocity = dir  * speed
	navigation_agent.velocity = intented_velocity
	move_and_slide()
	
func make_path():
	navigation_agent.set_target_position(target.global_position) 
	
func rotate_sprite():
	var dir_to_target = position.direction_to(target.global_position)
	
	if dir_to_target.x < 0:
		animation.scale.x = -1
	elif dir_to_target.x > 0:
		animation.scale.x = 1

func check_if_player_is_visible()-> bool:
	if get_node_or_null("RayNode") != null:
		direct_raycast_to_target()
		for ray in get_node("RayNode").get_children():
			if ray.is_colliding() and ray.get_collider() is Player:
				return true
	return false

func take_damage(damage):
	var label = preload("res://DamageLabel.tscn").instantiate()
	
	label.global_position = global_position
	label.set_damage(damage)
	add_child(label)
	health -= damage
	%ProgressBar.value = health
	if health <= 0:
		queue_free()

func throw_spell():
	var spell = PortalScene.instantiate()
	spell.position = player.position
	add_child(spell)

func _on_timer_timeout():
	if current_state == MOB_STATE.FOLLOWING:
		throw_spell()

func _on_detect_area_body_entered(body):
	if body is Player:
		target = body
		current_state = MOB_STATE.AIMING
		generate_raycasts()

func _on_detect_area_body_exited(body):
	if body is Player:
		current_state = MOB_STATE.IDLE

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
