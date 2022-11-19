extends Spatial

signal camera_info

export(NodePath) var cameraNode
var camera

func _ready():
	camera = get_node(cameraNode)

func _physics_process(delta):
	emit_signal("camera_info", camera.global_translation)
	pass
