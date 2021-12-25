extends Node

class_name Context

const MoonProto = preload("res://client/context/moon_proto.gd")
const Network = preload("res://client/network/net_v2.gd")

var netHandler = null
var player_data = {}

func _ready():
	netHandler = Network.new()
	
func initContext():
	# network
	# - security
	# 
	pass

func ini_multiplayer():
	# network
	pass
	
func encode_player_data():
	var data = MoonProto.PlayerInfo.new()
	var type = MoonProto.PlayerInfo.TypeNode.new()
	
	data.set_type_node(type)
	data.set_health(100)
	data.set_global_position([10,20,30])
	data.set_rotation([0,0,0])
	netHandler.set_data(data)
	
	
func decode_player_data():
	for item_key in netHandler.players_net.keys():
		player_data[item_key] = _decode_player(netHandler.players_net[item_key])
	
func _decode_player(bytes):
	var player = MoonProto.PlayerInfo.new()
	var state = player.from_bytes(bytes)
	
	# Debug check https://github.com/oniksan/godobuf Unpack result code
	print(state)
	if state == MoonProto.PB_ERR.NO_ERRORS:
		print("Data received")
	
	print(player.get_health())
	print(player.get_global_position())
	print(player.get_rotation())
	
	
	return 0
