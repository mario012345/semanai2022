extends RigidBody2D

var move = Vector2.ZERO
# Detect player direction
var lookVector = Vector2.ZERO
var player = null
var speed = 0
var bulletInitialDistance = Vector2.ZERO
var bulletFinalDistance = Vector2.ZERO

onready var Asprite = $AnimatedSprite

func _ready():
	#Calculate distance between player and bullet position
	lookVector = player.position - global_position
	#Calculate initial position of bullet
	bulletInitialDistance = global_position

func _physics_process(delta):
	speed += 0.05
	
	if lookVector.x >= 0:
		Asprite.flip_h = true
	else: Asprite.flip_h = false
	
	move = move.move_toward(lookVector, delta)
	move = move.normalized() * speed
	bulletFinalDistance = global_position - bulletInitialDistance
	position += move
	
	if abs(bulletFinalDistance.x) > 1000 or abs(bulletFinalDistance.y) > 1000:
		queue_free()
	#print(bulletFinalDistance)
	
