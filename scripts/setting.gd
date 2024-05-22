extends Control


signal create_host
signal join_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	create_host.emit()


func _on_client_pressed():
	join_game.emit()
