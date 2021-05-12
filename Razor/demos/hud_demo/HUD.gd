extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var jewels
var bullets 
var health_number
var health_bar
var coins 
var lives

func _ready():
	# Called when the node is added to the scene for the first time.
	## Initialization here
	jewels=$MarginContainer/HBoxContainer/Counter3/Background/Number
	coins=$MarginContainer/HBoxContainer/Counter2/Background/Number
	lives=$MarginContainer/HBoxContainer/Counter/Background/Number
	#lives.text =  str(playerdata.stats["lives"])
	health_number= $MarginContainer/HBoxContainer/Bars/Bar/Count/Background/Number
	health_bar =$MarginContainer/HBoxContainer/Bars/Bar/Gauge
	bullets = $MarginContainer/HBoxContainer/Counter4/Background/Number 
	# res://assets/HUD/rupees_icon.png
	#print(bombs.text)
func _process(delta):
	bullets.text = str(PlayerData.items["bullets"])
	#health_bar.Radial_ = str(PlayerData.stats["health"])
	jewels.text =  str(PlayerData.items["jewels"])
	coins.text =  str(PlayerData.items["coins"])
	health_number.text = str(PlayerData.stats["health"])
	lives.text = str(PlayerData.stats["lives"])
	
	pass
