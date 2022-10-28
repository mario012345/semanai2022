extends "res://src/Actors/Actor.gd"

var direction = Vector2.RIGHT #(0,1) * -1 = (-1,0)
var velocity = 250
var raycast_position = 31
var flag = true

onready var ledgeCheck = $LedgeCheck
onready var Asprite = $AnimatedSprite

var motion = Vector2()
const up = Vector2(0,-1)

func _physics_process(delta):
	motion.y += 5
	var found_wall = is_on_wall()
	var found_floor = is_on_floor()
	var found_ledge = not ledgeCheck.is_colliding()
	
	Asprite.play("walking")
	#print(found_wall,found_ledge)
	if found_wall or found_ledge and found_floor:
		direction = -1
		Asprite.flip_h = flag
		if flag == true:
			flag = false
			ledgeCheck.position.x = raycast_position
		else: 
			flag = true
			ledgeCheck.position.x = -raycast_position
		motion.x = velocity
		velocity = velocity * -1
	elif found_floor == false:
		motion.x = 0
	else:
		motion.x = velocity * -1
		
	move_and_slide(motion,up)

func _on_RollingEnemyArea_body_entered(body:Node):
	print(body.get_name())
	if body.get_name() == "Weapon":
		queue_free()
