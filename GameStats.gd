extends Node

var killed_mobs_count = 0

signal on_gate_open(gate_no)

func _ready():
	Events.on_mob_killed.connect(on_mob_killed)

func on_mob_killed():
	killed_mobs_count += 1
	if killed_mobs_count > 3:
		emit_signal("on_gate_open", 1)
