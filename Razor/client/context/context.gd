extends Node

class_name Context

const MoonProto = preload("res://client/context/moon_proto.gd")

var player_data = {}

func _ready():
	pass
	
func ini_multiplayer():
	# network
	pass
	
func encode_player_data():
	var data = MoonProto.PlayerInfo.new()
	#var type = MoonProto.PlayerInfo.TypeNode.new()
	
	#data.set_type_node(type)
	data.set_health(100)
	data.add_global_position(10)
	data.add_rotation(14)
	return data
	
	
func decode_player_data(players):
	for item_key in players.keys():
		player_data[item_key] = _decode_player(players[item_key])
	
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
