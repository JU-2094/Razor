extends Node2D
export var speed: float = 30
export var fall_acceleration: float = 75
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var body: KinematicBody

# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_parent()

func _physics_process(delta):
	ft_process(delta)

func ft_process(delta):
	
	var direction: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x -= 1
	if Input.is_action_pressed("ui_left"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.z += 1
	if Input.is_action_pressed("ui_down"):
		direction.z -= 1
	if direction != Vector3.ZERO:
		# Turn around the character when moving
		direction = direction.normalized()
		lastDirection = direction
		var dot_product = Vector2(direction.x, direction.z).dot(Vector2(0,1))
		var degrees = rad2deg(acos(dot_product))
		var angle = degrees if direction.x >= 0 else degrees * -1
		# dot product 1 - 0 degrees, -1 - 180 degrees
		# x is the orientation
		body.set_rotation_degrees(Vector3(0,angle,0))

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	# Apply movement to player object
	velocity = body.move_and_slide(velocity, Vector3.UP)
