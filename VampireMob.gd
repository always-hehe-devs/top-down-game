extends Enemy

var speed = 40

@onready var animation = $AnimatedSprite2D
const PortalScene: PackedScene = preload("res://Portal.tscn")

var health = 100
var is_following = false

enum MOB_STATE {IDLE, FOLLOWING, AIMING }

var target = null

var current_state = MOB_STATE.IDLE

func _physics_process(_delta):
	
	match current_state:
		MOB_STATE.IDLE:
			print('')
		MOB_STATE.AIMING:
			var is_visible = check_if_player_is_visible()
			if is_visible:
				current_state = MOB_STATE.FOLLOWING
		MOB_STATE.FOLLOWING:
			var is_visible = check_if_player_is_visible()
			if is_visible:
				move()
			else:
				current_state = MOB_STATE.AIMING
	

func move():
	rotate_sprite()
	velocity = position.direction_to(target.global_position) * speed
	
	if position.distance_to(target.global_position) > 23:
		move_and_slide()

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
	current_state = MOB_STATE.IDLE
