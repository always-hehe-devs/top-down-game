extends CharacterBody2D

var speed = 100
var health = 100
@onready var animation = $AnimatedSprite2D

const FireballScene: PackedScene = preload("res://Fireball.tscn")
const WaterballScene: PackedScene = preload("res://Waterball.tscn")

var current_attack = "attack_1"

func _ready():
	animation.play("Idle")

func _physics_process(_delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var mouse_dir = get_global_mouse_position() - position;

	if mouse_dir.x < 0:
		animation.scale.x = -1
	elif mouse_dir.x > 0:
		animation.scale.x = 1
	
	velocity = input_dir * speed
	
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		match current_attack:
			"attack_1":
				shoot(FireballScene)
			"attack_2":
				shoot(WaterballScene)	
				
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
