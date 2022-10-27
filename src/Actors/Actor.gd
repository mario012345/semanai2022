# Based on platform2D from Godot
extends KinematicBody2D

var health = 100
var speed = Vector2.ZERO
var gravity = 1200
var is_attacking = false
var is_shooting = false
var is_flipped = false

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	_velocity.y += gravity * delta
