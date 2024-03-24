extends Projectile

func proj_physics_process(delta):
	position += direction * speed * delta

func on_hit():
	speed = 0
	destroy = true
	on_destroy()

func init_animation():
	sprite.play("Move")

func on_destroy():
	sprite.play("Explode")

func _on_impact_detector_body_entered(body):
	if body.name.contains('TileMap'):
		on_hit()
		
func deflect():
	var new_direction = direction * -1
	direction = new_direction
	rotate(PI)
	hitbox.set_collision_layer_value(4,true)
	hitbox.set_collision_layer_value(10,false)
