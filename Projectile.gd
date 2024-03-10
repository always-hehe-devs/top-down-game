extends Node2D
class_name Projectile

var direction := Vector2.ZERO
var speed = 100
@onready var hitbox := $HitBox
@onready var sprite := $AnimatedSprite2D

var destroy = false

func _ready():
	top_level = true
	look_at(position + direction)
	init_animation()

func _physics_process(delta):
	proj_physics_process(delta)
	if destroy and not sprite.is_playing():
		queue_free()

func proj_physics_process(_delta):
	pass
	
func on_hit():
	speed = 0
	destroy = true
	on_destroy()

func init_animation():
	pass

func on_destroy():
	pass

