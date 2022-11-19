extends Node3D

signal camera_info

@export var cameraNode: NodePath
var camera

func _ready():
	camera = get_node(cameraNode)

func _physics_process(delta):
	emit_signal("camera_info", camera.global_translation)
	pass
