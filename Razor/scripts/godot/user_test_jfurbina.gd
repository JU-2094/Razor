extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cbck = {}
var arr1 = [1,2]
var arr2 = ['s1', 's2']
var mth
# Called when the node enters the scene tree for the first time.
onready var bgproc = preload("res://client/bgproc/bgproc.gd").new()
onready var network = preload("res://client/network/network.gd").new()

func local_test(vars):
	print("local_test function")

func _ready():
	print("Test ini")
	
	# BACKGROUND tests
	#var rfun = funcref(self, 'local_test')
	#rfun.call_func(null)
	
	# bgproc.bg_init(self)
	# bgproc.add_cts(self, 'local_test', 'mreg')
	
	# NETWORK tests
	
	network.net_init()
	network.net_conn2ser_rem()
	
	
	print("Test fini")

