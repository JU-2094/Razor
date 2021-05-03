extends Position3D

export var distance: float = 15.0

func _process(delta):
	var target: Vector3 = get_parent().get_node("Player") \
		.global_transform.origin
	var pos: Vector3 = global_transform.origin
	
	var new_pos: Vector3 = Vector3(
		pos.x - target.x , 0, pos.z - target.z - distance).normalized()
	
	pos.x = target.x
	pos.z = target.z + distance
	
	global_transform.origin = pos
