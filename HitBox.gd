extends Area2D
class_name HitBox

var damage := 10

@onready var collision_shape := $CollisionShape2D

func on_hit():
	get_parent().on_hit()

func set_disabled(is_disabled):
	collision_shape.disabled = is_disabled
