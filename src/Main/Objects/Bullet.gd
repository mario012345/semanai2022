extends Area2D

var move = Vector2.ZERO
# Detect player direction
var lookVector = Vector2.ZERO
var player = null
var speed = 10

func _ready():
	#Calculate distance between player and bullet position
	lookVector = player.position - global_position

func _physics_process(delta):
	move = move.move_toward(lookVector, delta)
	move = move.normalized() * speed
	position += move
