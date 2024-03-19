extends Sprite2D

@onready var tween := create_tween()

func _ready():
	tween.tween_property(self, "modulate:a",0.0,1)
	tween.finished.connect(func(): queue_free())
