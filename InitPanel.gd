extends Panel

@onready var button = $Button
@onready var world = $"../.."

func _ready():
	button.pressed.connect(on_button_pressed)

func on_button_pressed():
	world.get_tree().paused = false
	queue_free()
