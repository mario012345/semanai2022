extends "res://src/Actors/Actor.gd"

onready var bulletScene = preload("res://src/Objects/Bullet.tscn")
onready var Asprite = $AnimatedSprite

var player = null
var move = Vector2()
var distance = 0

const up = Vector2(0,-1)

func _on_Area2D_body_entered(body):
	if body != self:
		player = body

func _on_Area2D_body_exited(body):
	player = null
	
func fire():
	var bullet = bulletScene.instance()
	
	distance = player.position - self.position
	if distance.x >= 0:
		Asprite.flip_h = true
	else: Asprite.flip_h = false
	Asprite.play("shoot")
	
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(3)
	#print(distance)
	
func _on_Timer_timeout():
	if player != null:
		$Timer.autostart = true
		fire()

func _on_AnimatedSprite_animation_finished():
	Asprite.play("idle")

func _on_ShootingEnemy_body_entered(body):
	if body.get_name() == "Player":
		pass
		# Kill player
	else:
		hide()
		set_process(false)
		$Timer.stop()

func _on_Area2D2_body_entered(body):
	print(body.get_name())
	if body.get_name() == "Weapon":
		queue_free()
