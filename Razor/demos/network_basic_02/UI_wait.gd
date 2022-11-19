extends Control

const Network = preload("res://client/network/net_v2.gd")
var netHandler = null

func _ready():	
	netHandler = Network.new()
	add_child(netHandler)

func _on_ConnectServer_pressed():
	netHandler.create_server()
	get_tree().change_scene_to_file("res://demos/network_basic_01/world_n.tscn")

func _on_ConnectClient_pressed():
	netHandler.connect_client()
	get_tree().change_scene_to_file("res://demos/network_basic_01/world_n.tscn")
