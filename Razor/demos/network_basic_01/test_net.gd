extends Node2D

var isServer = false
const Context = preload("res://client/context/context.gd")
const Network = preload("res://client/network/net_v2.gd")
var contextHandler = null
var netHandler = null

func _ready():	
	contextHandler = Context.new()
	netHandler = Network.new()
	
	add_child(contextHandler)
	add_child(netHandler)
	var data = contextHandler.encode_player_data()
	netHandler.set_data(data)
	
	if isServer:
		print("I'M A SERVER")
		netHandler.create_server()
	else:
		print("I'M A CLIENT")
		netHandler.connect_client()
	
	print("REACHED TO END OF READY")
		
func _process(delta):
	
	#contextHandler.decode_player_data(netHandler.players_net)
	pass
	

func client_test():
	pass
	
func server_test():
	pass


