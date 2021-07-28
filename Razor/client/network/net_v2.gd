extends Node

class_name NetworkManager

var SERVER_IP: String = "192.168.1.166"
var SERVER_PORT: int = 50000
var CLIENT_PORT: int = 60000
var P2P_PORT: int =  31400
var MAX_CLIENTS: int = 32

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_CLIENTS)
	get_tree().network_peer = peer	

func get_ip():
	var addressList = IP.get_local_addresses()
	return addressList[0]

func connect_client():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

