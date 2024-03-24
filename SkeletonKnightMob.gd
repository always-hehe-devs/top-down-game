extends BaseMob

enum MOB_STATE {IDLE, FOLLOWING, AIMING, ATTACKING, DEAD, DEFENCE }

var current_state = MOB_STATE.IDLE

@onready var hitbox := $HitBox 
@onready var stance_timer := $ChangeStanceTimer
@onready var following_stance_timer := $FollowingStanceTimer

var rng = RandomNumberGenerator.new()

func _ready():
	hitbox.set_disabled(true)
	stance_timer.one_shot = true
	stance_timer.timeout.connect(change_stance)
	following_stance_timer.one_shot = true
	following_stance_timer.timeout.connect(change_following_stance)

func _physics_process(_delta):
	
	match current_state:
		MOB_STATE.IDLE:
			play_animation("Idle")
		MOB_STATE.AIMING:
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				switch_state(MOB_STATE.FOLLOWING)
		MOB_STATE.FOLLOWING:
			play_animation("Idle")
			var is_player_visible = check_if_player_is_visible()
			if is_player_visible:
				if following_stance_timer.is_stopped():
					following_stance_timer.start(rng.randf_range(2.0, 5.0))
				if global_position.distance_to(target.global_position) < 30:
					switch_state(MOB_STATE.ATTACKING)
				move()
			else:
				switch_state(MOB_STATE.AIMING)
		MOB_STATE.ATTACKING:
			following_stance_timer.stop()
			set_stance_timer()
			attack()
			move()
		MOB_STATE.DEFENCE:
			set_stance_timer()
			defend()
			move()
			
func attack():
	if global_position.distance_to(target.global_position) > 30:
		switch_state(MOB_STATE.FOLLOWING)
	hitbox.set_disabled(false)
	play_animation("Attack")
	
func defend():
	$HurtBox.set_disabled(true)
	play_animation("Defence")

func change_stance():
	if current_state == MOB_STATE.ATTACKING:
		switch_state(MOB_STATE.DEFENCE)
	elif current_state == MOB_STATE.DEFENCE:
		switch_state(MOB_STATE.ATTACKING)

func change_following_stance():
	if current_state == MOB_STATE.FOLLOWING:
		switch_state(MOB_STATE.DEFENCE)
	elif current_state == MOB_STATE.DEFENCE:
		switch_state(MOB_STATE.FOLLOWING)

func set_stance_timer():
	if stance_timer.is_stopped():
		stance_timer.start(rng.randf_range(2.0, 5.0))

func move():
	rotate_sprite()
	make_path()
	var next_path_position := navigation_agent.get_next_path_position()

	var dir = global_position.direction_to(next_path_position)
	var intented_velocity = dir  * speed
	navigation_agent.velocity = intented_velocity
	move_and_slide()

func on_body_entered(_body):
	switch_state(MOB_STATE.AIMING)

func on_body_exited(_body):
	switch_state(MOB_STATE.IDLE)

func play_animation(animation_name):
	if animation.animation != animation_name:
		animation.play(animation_name)

func switch_state(new_state):
	current_state = new_state
	if new_state != MOB_STATE.DEFENCE && $HurtBox.get_disabled():
		$HurtBox.set_disabled(false)

func _on_reflect_area_area_entered(area):
	if area.get_parent().has_method("deflect") && current_state == MOB_STATE.DEFENCE:
		area.get_parent().deflect()
