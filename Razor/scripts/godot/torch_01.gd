extends StaticBody

export (PackedScene) var fire_scene

func _on_Area_body_entered(body):
	#  print('Torch detected, body=', body)
	## Add logic to get more information
	set_fire_torch()
	pass # Replace with function body.

func set_fire_torch():
	var fire = fire_scene.instance()
	get_parent().add_child(fire)
	fire.global_translation = get_node("Position3D").global_translation
	fire.scale = Vector3(5,5,5)
