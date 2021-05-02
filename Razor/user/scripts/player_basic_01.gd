extends KinematicBody

signal hit

# Character speed in meters per second.
export var speed = 14
# Bounce property on objects. 
export var bounce_impulse = 16

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	pass

func _on_Area_body_entered(body):
	pass # Replace with function body.
