extends Projectile

@onready var impact_detector := $ImpactDetector

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
