extends Projectile
@onready var tween := create_tween()

func _ready():
	super()
	speed = 50
	tween.tween_property(self, "speed",100,1).set_ease(Tween.EASE_IN_OUT)

func proj_physics_process(delta):
	position += direction * speed * delta

func init_animation():
	sprite.play("Move")

func on_destroy():
	speed = 0
	destroy = true
	tween.stop()
	sprite.play("Explode")
	hitbox.set_collision_layer_value(10,false)

func _on_impact_detector_body_entered(body):
	if body.name.contains('TileMap'):
		on_hit()
		
func deflect():
	var new_direction = direction * -1
	direction = new_direction
	rotate(PI)
	hitbox.set_collision_layer_value(4,true)
	hitbox.set_collision_layer_value(10,false)
