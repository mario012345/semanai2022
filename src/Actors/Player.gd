extends "res://src/Actors/Actor.gd"

signal collect_coin 

const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var animated_sprite = $AnimatedSprite
onready var weapon_timer = $WeaponAnimation
# onready var sound_jump = $Jump
# onready var gun = sprite.get_node(@"Gun")

func _ready():
	# Static types are necessary here to avoid warnings.
	pass

func _physics_process(_delta):
	# Play jump sound
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# sound_jump.play()
		pass

	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# Flipping character
	if direction.x != 0:
		if direction.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	if Input.is_action_just_pressed("attack"):
		pass
		# is_attacking = gun.shoot(sprite.scale.x)

	# weapon usage
	#var animation = get_new_animation(is_shooting)
	#if animation != animation_player.current_animation and shoot_timer.is_stopped():
	#	if is_shooting:
	#		shoot_timer.start()
	#	animation_player.play(animation)
	animation_process()

func animation_process():
	$AnimatedSprite.play()	
	var animation_name = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_name = "walk"
		else:
			animation_name = "idle"
	else:
		if _velocity.y > 0:
			animation_name = "fall"
		else:
			animation_name = "jump"
	if is_attacking:
		animation_name = "weapon"
	$AnimatedSprite.animation = animation_name


func get_direction():
	return Vector2( Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), -1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(linear_velocity, direction, speed, is_jump_interrupted):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity
