extends Node2D
@export var speed: float = 30
@export var fall_acceleration: float = 75

var forward_camera = Vector2.ZERO
var forward_player = Vector2(0,1)
var lastDirection: Vector2 = Vector2.ZERO
var velocity: Vector3 = Vector3.ZERO
var body: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_parent()

func _physics_process(delta):
	ft_process(delta)

func ft_process(delta):
	
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x -= 1
	if Input.is_action_pressed("ui_left"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y += 1
	if Input.is_action_pressed("ui_down"):
		direction.y -= 1
	if direction != Vector2.ZERO:
		# Turn around the character when moving
		direction = direction.normalized()
		
		# Rotate direction with respect to forward camera
		var dot_product = forward_player.dot(forward_camera)
		var degrees = rad_to_deg(acos(dot_product))
		var angle = degrees * -1 if forward_camera.x >= 0 else degrees
		
		# TODO: to optimize we need to set the new local system of this node somehow
		# so we reduce rotations 
		direction = direction.rotated(deg_to_rad(angle))
		
		# Rotate body to respect to where will walk
		lastDirection = direction
		dot_product = direction.dot(Vector2(0,1))
		degrees = rad_to_deg(acos(dot_product))
		angle = degrees if direction.x >= 0 else degrees * -1
		# dot product 1 - 0 degrees, -1 - 180 degrees
		# x is the orientation
		body.set_rotation_degrees(Vector3(0,angle,0))

	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	velocity.y -= fall_acceleration * delta
	
	# Apply movement to player object
	body.set_velocity(velocity)
	body.set_up_direction(Vector3.UP)
	body.move_and_slide()
	velocity = body.velocity


func _on_Player_camera_info(camera_translation):
	# With the next code, the player is looking at the camara
	## get_parent().set_rotation_degrees(Vector3(0,camera_degrees,0)
	
	# The next code, is the direction from the camera to the player
	var dir_player = body.global_translation - camera_translation
	forward_camera = Vector2(dir_player.x, dir_player.z).normalized()
