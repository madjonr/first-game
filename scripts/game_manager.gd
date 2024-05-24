extends Node


const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 2080

@onready var score_label = $GameManager/ScoreLabel
@onready var coins_node = $Coins
@export var player_scene: PackedScene

var score = 0
var _player_spawn_node
var host_mode_enabled = false


func _ready():
	var coins = coins_node.get_children()
	for coin in coins:
		coin.pickup.connect(add_point)
	
	if SystemManager.peer_type == SystemManager.Peer_type.HOST:
		become_host()
	else :
		join_game()


func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."


func become_host():
	_player_spawn_node = get_tree().current_scene.get_node("Players")
	
	SystemManager.host_mode_enabled = true
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_add_player_to_game(1)
	
	
func join_game():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer
	print("CLIENT: player %s join game" % multiplayer.get_unique_id())

func _add_player_to_game(id:int = 1):
	print("SERVER: player %s connect game" % id)
	
	var player_to_add = player_scene.instantiate()
	player_to_add.name = str(id)
	player_to_add.player_id = id
	
	_player_spawn_node.add_child(player_to_add, true)


func _del_player(id: int):
	print("SERVER: player %s disconnect game" % id)
	if not _player_spawn_node.has_node(str(id)):
		return
	_player_spawn_node.get_node(str(id)).queue_free()
