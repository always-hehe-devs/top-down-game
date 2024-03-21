extends Node2D

@onready var label = $Label
@onready var tween := create_tween()

var velocity = Vector2(0,0)

var gravity := Vector2(0, 980)

func _init():
	top_level = true

func _ready() -> void:
	velocity = Vector2(randi_range(-100, 100), -200)
	tween.tween_property(self, "scale",Vector2(0,0),1.5).set_trans(Tween.TRANS_QUART)
	tween.finished.connect(func(): queue_free())

func _process(delta: float) -> void:
	gravity= gravity*0.95
	velocity += gravity * delta
	global_position += velocity * delta
	
func set_damage(amount:int):
	if not label:
		await ready
	label.text = "-"+str(amount)
