# Based on platform2D from Godot
extends "res://src/Actors/Actor.gd"

const FLOOR_DETECT_DISTANCE = 20.0

onready var platform_detector = $PlatformDetector
onready var animated_sprite = $AnimatedSprite
onready var weapon_timer = $WeaponTimer
onready var weapon_collision = $Weapon.get_children()[0]

var slice_vel = 200

func _ready():
	speed = Vector2(300.0, 800.0)

func _physics_process(_delta):
	var direction = get_direction()
	var snap_vector = Vector2.ZERO
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_on_platform = platform_detector.is_colliding()

	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	if !is_attacking:
		_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false)
	else:
		if !is_flipped: 
			_velocity = move_and_slide_with_snap(Vector2(slice_vel, 0), snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false)
		else:
			_velocity = move_and_slide_with_snap(Vector2(-slice_vel, 0), snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false)

	if !is_attacking:
		weapon_collision.disabled = true

	audio_process()
	animation_process()

func _input(event):
	if event.is_action_pressed("attack") && is_on_floor():
		is_attacking = true
		weapon_collision.disabled = false
		$AnimatedSprite.play("attack")

func animation_process():
	var direction = get_direction()
	if !is_attacking: 
		if is_on_floor():
			if abs(_velocity.x) > 0.1:
				$AnimatedSprite.play("walk")
			else:
				$AnimatedSprite.play("idle")
		elif !is_on_floor():
			if _velocity.y > 0:
				$AnimatedSprite.play("fall")
			else:
				$AnimatedSprite.play("jump")
	# Flipping character
	if direction.x != 0:
		if direction.x > 0:
			is_flipped = false
			$PlayerCollision.position.x = -28
			$Area2D/PlayerDeathCollision.position.x = -28
			weapon_collision.position.x = 90
			animated_sprite.flip_h = false
		else:
			is_flipped = true
			$PlayerCollision.position.x = 28
			$Area2D/PlayerDeathCollision.position.x = 28
			weapon_collision.position.x = -90
			animated_sprite.flip_h = true

func audio_process():
	if Input.is_action_just_pressed("jump") and not $JumpAudio.playing:
		$JumpAudio.play()
	elif Input.is_action_just_pressed("attack") and is_attacking and not $HitAudio.playing:
		$HitAudio.play()
	#elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and not $ExampleSoundPlayer.playing:
	#	$ExampleSoundPlayer.play()

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
		# Decrease the Y velocity by multiplying it, but don't set it to 0 as to not be too abrupt.
		velocity.y *= 0.6
	return velocity

func _on_AnimatedSprite_animation_finished():
	is_attacking = false;

func die():
	hide()
	$PlayerCollision.set_deferred("disabled", true)

func _on_Area2D_body_entered(body):
	print("Entra")
	print(body.get_name())
	if body:
		get_tree().reload_current_scene()
