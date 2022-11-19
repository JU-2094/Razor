extends Node

class_name NetworkManager

var SERVER_IP: String = "127.0.0.1"
var SERVER_PORT: int = 6007
var MAX_CLIENTS: int = 32

var players_net = {}
var client_data = null

func _ready():
	get_tree().connect("peer_connected",Callable(self,"_player_connected"))
	get_tree().connect("peer_disconnected",Callable(self,"_player_disconnected"))
	get_tree().connect("connected_to_server",Callable(self,"_connected_ok"))
	get_tree().connect("connection_failed",Callable(self,"_connected_fail"))
	get_tree().connect("server_disconnected",Callable(self,"_server_disconnected"))

func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT, MAX_CLIENTS)
	get_tree().network_peer = peer	

func get_ip():
	var addressList = IP.get_local_addresses()
	return addressList[0]

func connect_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

func refuse_new_connection():
	get_tree().network_peer.refuse_new_connections()

func _player_connected(id):
	# Called checked both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", client_data)

func _player_disconnected(id):
	players_net.erase(id)

func _connected_ok():
	pass # Only called checked clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

func set_data(data):
	client_data = data

# This will be executed in the server
@rpc(any_peer) func register_player(data):	
	var id = get_tree().get_remote_sender_id()
	print("REGISTER PLAYER")
	print("id= " + str(id))
	print("data= " + str(data))
	players_net[id] = data
