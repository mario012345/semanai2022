extends "res://src/Actors/Actor.gd"

onready var bulletScene = preload("res://src/Main/Objects/Bullet.tscn")
onready var Asprite = $AnimatedSprite

var player = null
var move = Vector2.ZERO

func _physics_process(delta):
	move = Vector2.ZERO
	
	if player != null and player.get_name() == "Player":
		#move = position.direction_to(player.position)
		pass
	else:
		move = Vector2.ZERO
	
	move = move.normalized()
	move = move_and_collide(move)

func _on_Area2D_body_entered(body):
	print(body.get_name())
	if body != self:
		player = body

func _on_Area2D_body_exited(body):
	player = null
	
func fire():
	var bullet = bulletScene.instance()
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(3)
	Asprite.play("shoot")
	print("Dispara")
	

func _on_Timer_timeout():
	print("Aqui entra")
	if player != null and player.get_name() == "Player":
		fire()

func _on_AnimatedSprite_animation_finished():
	Asprite.play("idle")
