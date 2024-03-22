extends CanvasLayer

@onready var active_rect = $ActiveRect
@onready var money_label = %MoneyLabel

var current_attack = "attack_1"

@onready var fireball: Sprite2D = $Fireball
@onready var waterball: Sprite2D = $Waterball

signal changed_attack(attack)

func _ready():
	Events.connect("player_attacked", on_player_attacked)
	Events.connect("set_total_money", on_money_change)

func _unhandled_key_input(event):
	if event.is_action(current_attack):
		return

	if event.is_action("attack_1"):
		active_rect.set_position(fireball.position + Vector2(-fireball.texture.get_width()/2.0-2, -fireball.texture.get_height()/2.0 -2))
		current_attack = "attack_1"
	elif event.is_action("attack_2"):
		active_rect.set_position(waterball.position + Vector2(-waterball.texture.get_width()/2.0 -2, -waterball.texture.get_height()/2.0 -2))
		current_attack = "attack_2"
	changed_attack.emit(current_attack)

func on_player_attacked(health):
	%ProgressBar.value = health
	
func on_money_change(amount):
	money_label.text = str(amount)
