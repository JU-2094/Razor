@tool
extends Node3D

enum MOTION_RANGE {
	UNUBSTRUCTED = 0,
	CONFORM_TO_CONTROLLER = 1
}

@export (MOTION_RANGE) var motion_range :
	get:
		return motion_range # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_motion_range
@export (Texture2D) var albedo_texture :
	get:
		return albedo_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_albedo_texture
@export (Texture2D) var normal_texture :
	get:
		return normal_texture # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_normal_texture

var material : StandardMaterial3D

func set_motion_range(value):
	motion_range = value
	if is_inside_tree():
		_update_motion_range()

func _update_motion_range():
	# for some reason not consistantly named between the two hands..
	if $HandModel.find_child("Armature001"):
		$HandModel/Armature001/Skeleton3D.motion_range = motion_range
	else:
		$HandModel/Armature/Skeleton3D.motion_range = motion_range

func set_albedo_texture(value):
	albedo_texture = value
	if is_inside_tree():
		_update_albedo_texture()

func _update_albedo_texture():
	if material:
		material.albedo_texture = albedo_texture

func set_normal_texture(value):
	normal_texture = value
	if is_inside_tree():
		_update_normal_texture()

func _update_normal_texture():
	if material:
		material.normal_texture = normal_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	if $HandModel.find_child("Armature001"):
		material = $HandModel/Armature001/Skeleton3D/vr_glove_left_slim.mesh.surface_get_material(0)
	else:
		material = $HandModel/Armature/Skeleton3D/vr_glove_right_slim.mesh.surface_get_material(0)

	_update_motion_range()
	_update_albedo_texture()
	_update_normal_texture()
