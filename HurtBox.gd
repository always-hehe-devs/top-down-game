extends Area2D
class_name HurtBox

@onready var collision_shape := $CollisionShape2D

func _init() -> void:
	monitorable = false
	
func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox):
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		hitbox.on_hit()
	if owner.has_method("knock_back"):
		owner.knock_back(hitbox.global_position)
		
		
func set_disabled(is_disabled):
	collision_shape.disabled = is_disabled
	
func get_disabled():
	return collision_shape.disabled
