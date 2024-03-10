extends Projectile

@onready var impact_detector := $ImpactDetector

func _physics_process(delta):
	proj_physics_process(delta)
	if destroy and not sprite.is_playing():
		queue_free()

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
	if body.name == 'TileMap':
		on_hit()
