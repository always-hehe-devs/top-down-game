extends CharacterBody2D

var speed = 20

@onready var player = $"../Player"
@onready var animation = $AnimatedSprite2D
const PortalScene: PackedScene = preload("res://Portal.tscn")

var health = 100
var is_following = false

func _physics_process(_delta):
	var dir_to_target = position.direction_to(player.global_position)
	
	if dir_to_target.x < 0:
		animation.scale.x = -1
	elif dir_to_target.x > 0:
		animation.scale.x = 1
	
	if is_following:
		velocity = position.direction_to(player.global_position) * speed
	
		if position.distance_to(player.global_position) > 23:
			move_and_slide()

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
	if is_following:
		throw_spell()

func _on_detect_area_body_entered(body):
	if body != owner:
		is_following = true

func _on_detect_area_body_exited(body):
	is_following = false
