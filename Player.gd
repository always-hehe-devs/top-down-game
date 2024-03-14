extends CharacterBody2D

var normal_speed = 100
var health = 100
@onready var animation = $AnimatedSprite2D

const FireballScene: PackedScene = preload("res://Fireball.tscn")
const WaterballScene: PackedScene = preload("res://Waterball.tscn")

@onready var hurtbox = $HurtBox

var current_attack = "attack_1"
var mouse_dir
var is_dashing = false;
var dash_speed = 400;
var dash_duration = 0.1

func _ready():
	animation.play("Idle")

func _physics_process(_delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	mouse_dir = get_global_mouse_position() - position;
	
	var speed
	
	if is_dashing:
		speed = dash_speed
		set_collision_mask_value(3,false)
		hurtbox.set_disabled(true)
	else:
		speed = normal_speed
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

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		match current_attack:
			"attack_1":
				shoot(FireballScene)
			"attack_2":
				shoot(WaterballScene)	
	if event.is_action_pressed("ui_select"):
		dash()
		
func dash():
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = 0.1
	timer.timeout.connect(func():is_dashing = false)
	timer.start()
	is_dashing = true;

func shoot(projectile: PackedScene) -> void:
	var bullet = projectile.instantiate()
	bullet.position = global_position
	bullet.direction = global_position.direction_to(get_global_mouse_position())
	add_child(bullet)

func take_damage(damage):
	health -= damage
	%ProgressBar.value = health

func _on_hud_changed_attack(attack):
	current_attack = attack
