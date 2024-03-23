class_name BaseMob extends Enemy

@onready var animation := $AnimatedSprite2D
@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D

var speed = 40
var health = 100
var is_following = false
var target = null
var is_dead = false
	
func make_path():
	navigation_agent.set_target_position(target.global_position) 
	
func rotate_sprite():
	var dir_to_target = position.direction_to(target.global_position)
	var hitbox = get_node_or_null("HitBox")
		
	if dir_to_target.x < 0:
		if hitbox:
			hitbox.scale.x = -1
		animation.scale.x = -1
	elif dir_to_target.x > 0:
		if hitbox:
			hitbox.scale.x = 1
		animation.scale.x = 1

func take_damage(damage):
	var label = preload("res://DamageLabel.tscn").instantiate()
	
	label.global_position = global_position
	label.set_damage(damage)
	add_child(label)
	health -= damage
	%ProgressBar.value = health
	if health <= 0 && !is_dead:
		death()

func _on_detect_area_body_entered(body):
	if body is Player:
		target = body
		on_body_entered(body)
		generate_raycasts()

func on_body_entered(_body):
	pass
	
func _on_detect_area_body_exited(body):
	if body is Player:
		on_body_exited(body)
		
func on_body_exited(_body):
	pass
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	
func death():
	is_dead = true
	var coin = preload("res://Coin.tscn").instantiate()
	coin.global_position = global_position
	await get_parent().call_deferred("add_child",coin)
	Events.emit_signal("on_mob_killed")
	
	queue_free()

