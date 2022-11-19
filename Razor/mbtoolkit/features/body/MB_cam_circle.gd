extends Marker3D

@export var distance: float = 1.0
@export var height_from_floor: float = 1.0
@export var theta: float = 180
@export var target_path: NodePath

func _ready():
	position.y = height_from_floor

func _process(delta):
	# Position of the object to follow with local coordinates
	# The global coordinates are not updating when moving
	var target: Vector3 = get_node(target_path).get_node("Body").global_translation

	look_at(Vector3(target.x, 0, target.z), Vector3.UP)
	position.x = target.x + distance*sin(deg_to_rad(theta))
	position.z = target.z + distance*cos(deg_to_rad(theta))
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			if event.relative.x > 0:
				theta = theta + 2
			elif event.relative.x < 0:
				theta = theta - 2
