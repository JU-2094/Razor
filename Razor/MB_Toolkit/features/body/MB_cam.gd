extends Position3D

export var distance: float = 15.0
export var height_from_floor: float = 20.0
export(NodePath) var target_path

func _process(delta):
	# Position of the object to follow
	var target: Vector3 = get_node(target_path).get_node("Body").global_transform.origin
	
	# Relative position to the world
	var pos: Vector3 = global_transform.origin
	
	print(pos)
	print(target)
	
	pos.y = height_from_floor
	pos.x = target.x
	pos.z = target.z - distance
	
	global_transform.origin = pos
