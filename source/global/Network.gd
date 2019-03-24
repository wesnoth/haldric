extends Node

# O V E R R I D E

func _ready() -> void:
	set_pause_mode(PAUSE_MODE_PROCESS)
	get_tree().connect("network_peer_connected",self,"_on_player_connected")
	get_tree().connect('connected_to_server', self, '_on_connected_to_server')
	get_tree().connect("network_peer_disconnected",self,"_on_player_disconnected")
	get_tree().connect("server_disconnected",self,"_on_server_disconnected")

# P U B L I C

func create_server(port : int) -> bool:
	var peer := NetworkedMultiplayerENet.new()
	if peer.create_server(port, 1) != OK:
		return false
	get_tree().set_network_peer(peer)
	return true

func create_client(ip : String, port : int) -> bool:
	if not ip.is_valid_ip_address():
		return false
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().set_network_peer(peer)
	return true

# O N   S I G N A L

func _on_player_connected(id) -> void:
	print(id, " connected")

func _on_connected_to_server() -> void:
	print("connection stable")

func _on_player_disconnected(id) -> void:
	get_tree().set_network_peer(null)
	print(id, " disconnected")

func _on_server_disconnected() -> void:
	get_tree().set_network_peer(null)
	print("server closed")