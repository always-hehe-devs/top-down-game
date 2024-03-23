extends Node2D

var velocity = Vector2(0,0)

var gravity := Vector2(0, 980)
	
func _init():
	top_level = true

var initial_position
var target

func _ready() -> void:
	initial_position = global_position
	velocity = Vector2(randi_range(-50, 50), -200)

func _physics_process(delta: float) -> void:
	if global_position.y <= initial_position.y:
		gravity= gravity*0.95
		print(gravity)
		velocity += gravity * delta
		global_position += velocity * delta
	if target:
		if target.global_position.distance_to(global_position) < 10:
			queue_free()
		move_to_target()

func _on_area_2d_body_entered(body):
	if body.has_method("increase_money"):
		body.increase_money(10)
		target = body

func move_to_target():
	global_position = lerp(global_position, target.global_position, 0.2)
	
