extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var jewels
var health
var coins 
var lives

func _ready():
	# Called when the node is added to the scene for the first time.
	## Initialization here
	jewels=$MarginContainer/HBoxContainer/Counter3/Background/Number
	coins=$MarginContainer/HBoxContainer/Counter2/Background/Number
	lives=$MarginContainer/HBoxContainer/Counter/Background/Number
	#lives.text =  str(playerdata.stats["lives"])
	health= $MarginContainer/HBoxContainer/Bars/Bar/Count/Background/Number
	# res://assets/HUD/rupees_icon.png
	#print(bombs.text)
func _process(delta):
	#bombs.text =  str(playerdata.items["bombs"])
	#oins.text =  str(playerdata.items["coins"])
	#ealth.text = str(playerdata.stats["health"])
	
	pass
