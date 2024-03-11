extends Area2D
class_name HurtBox

func _init() -> void:
	monitorable = false
	
func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox):
	print(hitbox)
	if hitbox.owner.get_parent() != owner && owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		hitbox.on_hit()
