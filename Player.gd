extends CharacterBody2D

class_name Player

var normal_speed = 100
var health = 100
var money = 0
@export var curve:Curve
@onready var animation = $AnimatedSprite2D
@onready var dash = $Dash

const FireballScene: PackedScene = preload("res://Fireball.tscn")
const WaterballScene: PackedScene = preload("res://Waterball.tscn")

@onready var hurtbox = $HurtBox

var current_attack = "attack_1"
var mouse_dir
var input_dir = Vector2(0,0)
var time = 0
var max_time = 2

func _ready():
	animation.play("Idle")

func _physics_process(_delta):
	mouse_dir = get_global_mouse_position() - position;
	
	var speed = 0
	if dash.is_dashing():
		speed = dash.speed
		set_collision_mask_value(3,false)
		hurtbox.set_disabled(true)
	else:
		time +=_delta
		var new_speed = normal_speed * curve.sample(time/max_time)
		speed = new_speed
		set_collision_mask_value(3,true)
		hurtbox.set_disabled(false)
	
	if mouse_dir.x < 0:
		animation.scale.x = -1
	elif mouse_dir.x > 0:
		animation.scale.x = 1
	
	if input_dir != Vector2(0,0):
		animation.play("Run")
	else:
		animation.play("Idle")
	
	velocity = input_dir * speed
	
	move_and_slide()

func _input(event):
	var new_input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir == Vector2(0,0):
		time = 0
	input_dir = new_input_dir
	if event.is_action_pressed("left_click"):
		match current_attack:
			"attack_1":
				shoot(FireballScene)
			"attack_2":
				shoot(WaterballScene)	
	if event.is_action_pressed("dash"):
		dash.start_dash()
	

func shoot(projectile: PackedScene) -> void:
	var bullet = projectile.instantiate()
	bullet.position = global_position
	bullet.direction = global_position.direction_to(get_global_mouse_position())
	add_child(bullet)
	
func take_damage(damage):
	health -= damage
	Events.player_attacked.emit(health)

func _on_hud_changed_attack(attack):
	current_attack = attack

func increase_money(amount):
	money +=amount
	Events.set_total_money.emit(money)
