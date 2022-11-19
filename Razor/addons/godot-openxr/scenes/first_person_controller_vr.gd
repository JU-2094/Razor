@tool
extends XROrigin3D

signal initialised
signal failed_initialisation

# Also add signals so we can have other parts of the application react to this.
signal session_begun
signal session_ending
signal session_idle
signal session_synchronized
signal session_loss_pending
signal session_exiting
signal focused_state
signal visible_state
signal pose_recentered

@export var auto_initialise = true :
	get:
		return auto_initialise # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_auto_initialise
@export var enable_passthrough = false :
	get:
		return enable_passthrough # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_enable_passthrough
@export (NodePath) var viewport :
	get:
		return viewport # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_viewport
@export var near_z = 0.1
@export var far_z = 1000.0

var interface : XRInterface
var enabled_extensions : Array

func set_auto_initialise(p_new_value):
	auto_initialise = p_new_value
	update_configuration_warnings()

func set_enable_passthrough(p_new_value):
	enable_passthrough = p_new_value
	update_configuration_warnings()

	# Only actually start our passthrough if our interface has been instanced
	# if not this will be delayed until initialise is successfully called.
	if interface:
		if enable_passthrough:
			# unset enable_passthrough if we can't start it.
			enable_passthrough = _start_passthrough()
		else:
			_stop_passthrough()

func set_viewport(p_new_value):
	viewport = p_new_value
	update_configuration_warnings()

func get_interface() -> XRInterface:
	return interface

func _ready():
	$XRCamera3D.near = near_z
	$XRCamera3D.far = far_z

	if auto_initialise && !Engine.editor_hint:
		initialise()

func initialise() -> bool:
	if Engine.editor_hint:
		print("Can't initialise while in the editor")
		return false

	if interface:
		# we are already initialised
		return true

	interface = XRServer.find_interface("OpenXR")
	if interface and interface.initialize():
		print("OpenXR Interface initialized")

		# Find the viewport we're using to render our XR output
		var vp : SubViewport = _get_xr_viewport()

		# Obtain enabled extensions
		enabled_extensions = $Configuration.get_enabled_extensions()

		# Start passthrough?
		if enable_passthrough and is_passthrough_supported():
			enable_passthrough = _start_passthrough()

		# Connect to our plugin signals
		_connect_plugin_signals()

		# Change our viewport so it is tied to our ARVR interface and renders to our HMD
		vp.arvr = true

		# We can't set keep linear yet because we won't know the correct value until after our session has begun.

		# increase our physics engine update speed
		var refresh_rate = $Configuration.get_refresh_rate()
		if refresh_rate == 0:
			# Only Facebook Reality Labs supports this at this time
			print("No refresh rate given by XR runtime")

			# Use something sufficiently high
			Engine.physics_ticks_per_second = 144
		else:
			print("HMD refresh rate is set to " + str(refresh_rate))

			# Match our physics to our HMD
			Engine.physics_ticks_per_second = refresh_rate

		emit_signal("initialised")
		return true
	else:
		interface = null

		emit_signal("failed_initialisation")
		return false

func _get_xr_viewport() -> SubViewport:
	if viewport:
		var vp : SubViewport = get_node(viewport)
		return vp
	else:
		return get_viewport()

func is_passthrough_supported() -> bool:
	var supported = enabled_extensions.find("XR_FB_passthrough") >= 0
	return supported

func _start_passthrough() -> bool:
	# make sure our viewports background is transparent
	_get_xr_viewport().transparent_bg = true

	# enable our passthrough
	return $Configuration.start_passthrough()

func _stop_passthrough():
	# make sure our viewports background is not transparent
	_get_xr_viewport().transparent_bg = false

	$Configuration.stop_passthrough()

func _connect_plugin_signals():
	XRServer.connect("openxr_session_begun",Callable(self,"_on_openxr_session_begun"))
	XRServer.connect("openxr_session_ending",Callable(self,"_on_openxr_session_ending"))
	XRServer.connect("openxr_session_idle",Callable(self,"_on_openxr_session_idle"))
	XRServer.connect("openxr_session_synchronized",Callable(self,"_on_openxr_session_synchronized"))
	XRServer.connect("openxr_session_loss_pending",Callable(self,"_on_openxr_session_loss_pending"))
	XRServer.connect("openxr_session_exiting",Callable(self,"_on_openxr_session_exiting"))
	XRServer.connect("openxr_focused_state",Callable(self,"_on_openxr_focused_state"))
	XRServer.connect("openxr_visible_state",Callable(self,"_on_openxr_visible_state"))
	XRServer.connect("openxr_pose_recentered",Callable(self,"_on_openxr_pose_recentered"))

func _on_openxr_session_begun():
	# This is called checked session ready.
	print("OpenXR session begun")

	var vp : SubViewport = _get_xr_viewport()
	if vp:
		# Our interface will tell us whether we should keep our render buffer in linear color space
		vp.keep_3d_linear = $Configuration.keep_3d_linear()

	emit_signal("session_begun")

func _on_openxr_session_ending():
	# This is called checked session stopping

	print("OpenXR session ending")
	emit_signal("session_ending")

func _on_openxr_session_idle():
	print("OpenXR session idle")
	emit_signal("session_idle")

func _on_openxr_session_synchronized():
	print("OpenXR session synchronized")
	emit_signal("session_synchronized")

func _on_openxr_session_loss_pending():
	print("OpenXR session loss pending")
	emit_signal("session_loss_pending")

func _on_openxr_session_exiting():
	print("OpenXR session exiting")
	emit_signal("session_exiting")

func _on_openxr_focused_state():
	print("OpenXR focused state")
	emit_signal("focused_state")

func _on_openxr_visible_state():
	print("OpenXR visible state")
	emit_signal("visible_state")

func _on_openxr_pose_recentered():
	print("OpenXR pose recentered")
	emit_signal("pose_recentered")

func _get_configuration_warnings():
	var version = Engine.get_version_info()

	if viewport:
		var vp = get_node(viewport)
		if !vp:
			return "Can't access assigned viewport"
		if !(vp is SubViewport):
			return "Selected viewport is not a viewport"
		if vp.render_target_update_mode != SubViewport.UPDATE_ALWAYS:
			return "SubViewport update mode is not set to always, you may not get proper output"

	if enable_passthrough and version['major'] == 3 and version['minor'] < 4:
		return "Godot %s is too old for the passthrough version. Please upgrade to Godot 3.4 or later." % version['string']

	if !auto_initialise:
		return "You must call initialise() manually for VR to start"

	return ""
