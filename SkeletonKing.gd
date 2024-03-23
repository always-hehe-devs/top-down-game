extends CharacterBody2D

@onready var animation_boss = $AnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 10
var is_dead = false

func _ready():
	animation_boss.play('Run')

func _physics_process(delta):
	pass

func take_damage(damage):
	var label = preload("res://DamageLabel.tscn").instantiate()
	
	label.global_position = global_position
	label.set_damage(damage)
	add_child(label)
	health -= damage
	%ProgressBar.value = health
	if health <= 0 && !is_dead:
		death()
		
func death():
	is_dead = true
	var coin = preload("res://Coin.tscn").instantiate()
	coin.global_position = global_position
	await get_parent().call_deferred("add_child",coin)
	Events.emit_signal("on_mob_killed")
	
	queue_free()
