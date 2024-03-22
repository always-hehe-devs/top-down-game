extends Node2D


func _ready():
	GameStats.on_gate_open.connect(on_open)

func on_open(level):
	if level == 1:
		queue_free()
