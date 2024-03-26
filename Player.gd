extends CharacterBody2D

class_name Player

@export var acc_curve:Curve
@export var deacc_curve:Curve
@onready var animation = $AnimatedSprite2D
@onready var dash = $Dash
@onready var hurtbox = $HurtBox

const FireballScene: PackedScene = preload("res://Fireball.tscn")

var normal_speed = 100
var health = 100
var money = 0
var mouse_dir
var input_dir = Vector2(0,0)
var acc_time = 0
var deacc_time = 0
var max_acc_time = 1
var max_deacc_time = 1
var speed = 0

enum STATE {IDLE,RUNNING,ATTACKING,DASHING}
var current_state = STATE.IDLE

func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			animation.play("Idle")
			handle_input()
		STATE.RUNNING:
			speed = normal_speed
			animation.play("Run")
			set_collision_mask_value(3,true)
			handle_input()
		STATE.DASHING:
			if animation.animation != "Dash":
				animation.play("Dash")
			speed = dash.speed
			set_collision_mask_value(3,false)
			hurtbox.set_disabled(true)
			if not dash.is_dashing():
				if is_moving():
					current_state = STATE.RUNNING
				else:
					current_state = STATE.IDLE
			dash.start_dash()
		STATE.ATTACKING:
			shoot(FireballScene)
			handle_input()
			
	handle_movement(delta)
	handle_mouse()
	handle_sprite_flip()
	
func handle_movement(delta):
	if not is_moving() and velocity != Vector2(0,0):
		deacc_time += delta
		velocity = velocity * deacc_curve.sample(deacc_time/max_deacc_time)
	elif is_moving():
		acc_time += delta
		velocity = input_dir * speed * acc_curve.sample(acc_time/max_acc_time)
	move_and_slide()

func is_moving():
	return input_dir != Vector2(0,0)

func handle_input():
	var new_input_dir = Input.get_vector("left", "right", "up", "down")
	input_dir = new_input_dir

	if not is_moving():
		acc_time = 0
		current_state = STATE.IDLE
	else:
		deacc_time = 0
		current_state = STATE.RUNNING
	
func handle_sprite_flip():
	if mouse_dir.x < 0:
		animation.scale.x = -1
	elif mouse_dir.x > 0:
		animation.scale.x = 1
		
func handle_mouse():
	mouse_dir = get_global_mouse_position() - position
	
func _input(event):
	if event.is_action_pressed("left_click"):
		current_state = STATE.ATTACKING
	if event.is_action_pressed("dash"):
		current_state = STATE.DASHING
		dash.start_dash()

func shoot(projectile: PackedScene) -> void:
	var bullet = projectile.instantiate()
	bullet.position = global_position
	bullet.direction = global_position.direction_to(get_global_mouse_position())
	add_child(bullet)
	
func take_damage(damage):
	health -= damage
	Events.player_attacked.emit(health)

func increase_money(amount):
	money +=amount
	Events.set_total_money.emit(money)
