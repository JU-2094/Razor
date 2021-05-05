extends KinematicBody

signal hit

# Character speed in meters per second.
export var speed: int = 14

var velocity: Vector3 = Vector3.ZERO
onready var BULLET = preload('res://objects/scenes/little_ball.tscn')
func _physics_process(delta):
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		# Turn around the character when moving
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 2
	else:
		$AnimationPlayer.playback_speed = 1
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# TODO(jfurbina@): logic for shooting
	if Input.is_action_pressed("ui_action1"):
		var b = BULLET.instance()
		owner.add_child(b)
		b.transform = $Pivot/Position3D.global_transform
		b.velocity = -b.transform.basis.z * b.muzzle_velocity
		pass
	
	# Apply movement to player object
	velocity = move_and_slide(velocity, Vector3.UP)
	
func die():
	emit_signal("hit")
	queue_free()
	
func _on_Area_body_entered(body):
	pass # Replace with function body.
