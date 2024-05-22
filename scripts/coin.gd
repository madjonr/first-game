extends Area2D


signal pickup

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	pickup.emit()
	animation_player.play("pickup")

