extends Marker3D

@export var distance: float = 1.0
@export var height_from_floor: float = 1.0
@export var target_path: NodePath
var init_origin: Vector3 = Vector3.ZERO

func _ready():
	init_origin = global_translation

func _process(delta):
	# Position of the object to follow with local coordinates
	# The global coordinates are not updating when moving
	var target: Vector3 = get_node(target_path).get_node("Body").position
	
	position.y = height_from_floor
	position.x = init_origin.x + target.x
	position.z = init_origin.z + target.z - distance
	
