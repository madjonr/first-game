extends Node


var game_scene_file = "res://scenes/game.tscn"

var peer_type
var host_mode_enabled = false
enum Peer_type {HOST, CLIENT}


# Called when the node enters the scene tree for the first time.
func _ready():
	var setting = $"../Setting"
	setting.create_host.connect(become_host)
	setting.join_game.connect(join_game)

func become_host():
	peer_type = Peer_type.HOST
	load_scene(game_scene_file)


func join_game():
	peer_type = Peer_type.CLIENT
	load_scene(game_scene_file)


func load_scene(scene_file):
	if ResourceLoader.exists(scene_file):
		get_tree().change_scene_to_file(scene_file)
	else :
		print("loading game scene ERROR")
