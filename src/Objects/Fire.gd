extends RigidBody2D

var player = null

onready var Asprite = $AnimatedSprite

func _on_Area2D_body_entered(body):
	if body != self:
		player = body
		Asprite.play("move")

func _on_Area2D_body_exited(body):
	Asprite.play("static")

func _on_FireArea_body_entered(body):
	pass
	#print(body.get_name())
	#if body.get_name() == "Player":
	#	print("Touched spikes")
