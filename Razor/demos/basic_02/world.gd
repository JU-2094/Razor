extends Spatial

func _ready():
	pass

func _process(delta):
	pass


func _on_Attacker_notify(body):
	var player = get_node("Player")
	if (body == player):
		player.decrease_health()
	

func _on_Player_death():
	get_tree().quit()


func _on_spaceship_01_death():
	get_tree().quit()
	
