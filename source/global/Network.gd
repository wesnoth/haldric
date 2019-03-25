extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 31400
const MAX_CLIENTS = 32

signal player_connected()
signal player_disconnected()

# Info of all connected players
var players := {}

# Info we send to other players
var me := {
	name = "Haldric"
}

# O V E R R I D E

func _ready() -> void:
	set_pause_mode(PAUSE_MODE_PROCESS)
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected",self,"_server_disconnected")

# P U B L I C

func create_server(player_name : String) -> bool:
	me.name = player_name
	players[1] = me
	var peer := NetworkedMultiplayerENet.new()
	if peer.create_server(DEFAULT_PORT, MAX_CLIENTS) != OK:
		return false
	get_tree().set_network_peer(peer)
	return true

func create_client(player_name, ip : String) -> bool:
	if not ip.is_valid_ip_address():
		return false
	var peer := NetworkedMultiplayerENet.new()

	match peer.create_client(ip, DEFAULT_PORT):
		ERR_ALREADY_IN_USE:
			print("Connection to %s already open", ip)
		ERR_CANT_CREATE:
			print("Cound not open connection to %s", ip)
		OK:
			print("Opened connection to %s", ip)

	get_tree().set_network_peer(peer)
	return true

# O N   S I G N A L

func _player_connected(id) -> void:
	print(players[id].name, " connected")

func _player_disconnected(id) -> void:
	print(players[id].name, " disconnected")
	players.erase(id)

func _connected_ok() -> void:
	# only called on clients, not on the server. Send my ID and info to all other peers
	print("Connection OK")
	rpc("register_player", get_tree().get_network_unique_id(), me)

func _connected_fail() -> void:
	print("Connection FAILED")

func _server_disconnected() -> void:
	get_tree().set_network_peer(null)
	print("Server CLOSED")

remote func register_player(id, info) -> void:
	players[id] = info

	# If I'm the server, let the new guys know about existing players.
	if get_tree().is_network_server():

		# send me to new player
		rpc_id(id, "register_player", 1, me)

		# send info about other existing players to new player
		for peer_id in players:
			rpc_id(id, "register_player", peer_id, players[peer_id])

	# update lobby ui