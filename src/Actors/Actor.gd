# Based on platform2D from Godot
extends KinematicBody2D

signal hit

var speed = Vector2(250.0, 200.0)
var gravity = 300
var is_attacking = false
var is_shooting = false

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	_velocity.y += gravity * delta
