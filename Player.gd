extends CharacterBody2D

var speed = 200
@onready var animation = $AnimatedSprite2D

	
func _ready():
	animation.play("Idle")

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir == Vector2(-1,0):
		animation.scale.x = -1
	elif input_dir == Vector2(1,0):
		animation.scale.x = 1
	
	velocity = input_dir * speed
	
	print(input_dir)
	move_and_collide(velocity * delta)
