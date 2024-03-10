extends Projectile

func _ready():
	super()
	hitbox.set_disabled(true)
	
func init_animation():
	sprite.play("Spin")

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation != "Explode":
		hitbox.set_disabled(false)
		sprite.play("Explode")
	else:
		queue_free()
