class_name FlashComponent
extends Node

@export var target: AnimatedSprite2D
@onready var flash_timer := Timer.new()
const FLASH_MATERIAL = preload("res://flash_material.tres")
var original_material

func _ready():
	original_material = target.material
	flash_timer.one_shot = true
	flash_timer.timeout.connect(on_flash_timeout)
	add_child(flash_timer)

func flash():
	if flash_timer.is_stopped():
		target.material = FLASH_MATERIAL
		flash_timer.start(0.1)
	
func on_flash_timeout():
	target.material = original_material
