extends Node3D

@export (NodePath) var configuration

@onready var configuration_node = get_node(configuration) if configuration else null

func _update_bounds():
	$CSGPolygon3D.visible = false
	if configuration_node:
		var polygon : PackedVector2Array
		var bounds = configuration_node.get_play_space()
		if bounds.size() > 0:
			# While in most conditions our polygon will be flat checked the ground but may be lifted up or down,
			# there are situations where it can be slanted (basically when CenterHMD is called with RESET_FULL_ROTATION which is seldom used)
			# We could improve this logic by calculating our plane and adjusting the position of our CSGPolygon3D accordingly.

			# For now we assume a flat plane and just move our CSGPolygon3D up/down
			$CSGPolygon3D.transform.origin.y = bounds[0].y;

			for i in 4:
				polygon.push_back(Vector2(bounds[i].x, bounds[i].z))

			$CSGPolygon3D.polygon = polygon
			$CSGPolygon3D.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$CSGPolygon3D.visible = false

	var origin = get_node("..")
	origin.connect("pose_recentered",Callable(self,"_update_bounds"))
	origin.connect("visible_state",Callable(self,"_update_bounds"))
