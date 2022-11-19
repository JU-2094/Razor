@tool
extends Node3D

signal pointer_entered
signal pointer_exited

@export var enabled = true :
	get:
		return enabled # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_enabled
@export var screen_size = Vector2(3.0, 2.0) :
	get:
		return screen_size # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_screen_size
@export var viewport_size = Vector2(300.0, 200.0) :
	get:
		return viewport_size # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_viewport_size
@export var transparent = true :
	get:
		return transparent # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_transparent
@export (PackedScene) var scene = null :
	get:
		return scene # TODOConverter40 Copy here content of get_scene
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_scene

# Need to replace this with proper solution once support for layer selection has been added
@export (int, LAYERS_3D_PHYSICS) var collision_layer = 15 :
	get:
		return collision_layer # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_collision_layer

var is_ready = false
var scene_node = null

func set_enabled(is_enabled: bool):
	enabled = is_enabled
	if is_ready:
		$StaticBody3D/CollisionShape3D.disabled = !enabled

func set_screen_size(new_size: Vector2):
	screen_size = new_size
	if is_ready:
		$Screen.mesh.size = screen_size
		$StaticBody3D.screen_size = screen_size
		$StaticBody3D/CollisionShape3D.shape.extents = Vector3(screen_size.x * 0.5, screen_size.y * 0.5, 0.01)

func set_viewport_size(new_size: Vector2):
	viewport_size = new_size
	if is_ready:
		$SubViewport.size = new_size
		$StaticBody3D.viewport_size = new_size
		var material : StandardMaterial3D = $Screen.get_surface_override_material(0)
		material.albedo_texture = $SubViewport.get_texture()

func set_transparent(new_transparent: bool):
	transparent = new_transparent
	if is_ready:
		var material : StandardMaterial3D = $Screen.get_surface_override_material(0)
		material.flags_transparent = transparent
		$SubViewport.transparent_bg = transparent

func set_collision_layer(new_layer: int):
	collision_layer = new_layer
	if is_ready:
		$StaticBody3D.collision_layer = collision_layer

func set_scene(new_scene: PackedScene):
	scene = new_scene
	if is_ready:
		# out with the old
		if scene_node:
			$SubViewport.remove_child(scene_node)
			scene_node.queue_free()

		# in with the new
		if scene:
			scene_node = scene.instantiate()
			$SubViewport.add_child(scene_node)

func get_scene():
	return scene

func get_scene_instance():
	return scene_node

func connect_scene_signal(which, checked, callback):
	if scene_node:
		scene_node.connect(which,Callable(checked,callback))

# Called when the node enters the scene tree for the first time.
func _ready():
	# apply properties
	is_ready = true
	set_enabled(enabled)
	set_screen_size(screen_size)
	set_viewport_size(viewport_size)
	set_scene(scene)
	set_collision_layer(collision_layer)
	set_transparent(transparent)
	set_process_input(true)

func _on_pointer_entered():
	emit_signal("pointer_entered")

func _on_pointer_exited():
	emit_signal("pointer_exited")

func _input(event):
	$SubViewport.input(event)
