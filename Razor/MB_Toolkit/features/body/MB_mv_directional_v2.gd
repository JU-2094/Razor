extends Node2D
export (float) var speed: float = 30
export (float) var angular_acceleration : float = 3
export var fall_acceleration: float = 75
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.FORWARD
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	ft_process(delta)


func ft_process(delta):
	var rot_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity = Vector3(0, -fall_acceleration * delta, Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")).normalized() 
	if rot_dir != 0:
		get_parent().rotation.y = lerp_angle(get_parent().rotation.y, get_parent().rotation.y - (PI/2 * rot_dir), delta * angular_acceleration)
	#Here animation if exist:
	velocity = get_parent().move_and_slide(velocity.rotated(Vector3.UP, get_parent().rotation.y) * speed, Vector3.UP)
