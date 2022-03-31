extends Node2D
export var speed: float = 30
export var fall_acceleration: float = 75
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var body: KinematicBody
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
		body.look_at(body.translation - direction, Vector3.UP)
		
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	# Apply movement to player object
	velocity = body.move_and_slide(velocity, Vector3.UP)
