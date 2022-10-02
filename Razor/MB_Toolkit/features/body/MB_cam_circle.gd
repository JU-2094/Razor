extends Position3D

export var distance: float = 1.0
export var height_from_floor: float = 1.0
export(NodePath) var target_path
var init_origin: Vector3 = Vector3.ZERO

func _ready():
	init_origin = global_translation
	translation.y = height_from_floor

func _process(delta):
	# Position of the object to follow with local coordinates
	# The global coordinates are not updating when moving
	var target: Vector3 = get_node(target_path).get_node("Body").global_translation
	
	# look_at(Vector3(target.x, 0, target.z), Vector3.UP)
	
	# translation.x = init_origin.x + target.x
	# translation.z = init_origin.z + target.z - distance
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			print('left click , relative pos=', event.relative)
	
