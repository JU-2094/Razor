extends KinematicBody

signal hit

# Character speed in meters per second.
export var speed: int = 14

var velocity: Vector3 = Vector3.ZERO
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
    	rng.randomize()
    	var random_number = rng.randi()
	var direction: Vector3 = Vector3.ZERO
	
	if randvar%3==0:
		direction.x += 1
	if randvar%7==0:
		direction.x -= 1
	if randvar%11==0:
		direction.z -= 1
	if randvar%13==0:	
		direction.z += 1
	
	if direction != Vector3.ZERO:
		# Turn around the character when moving
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		#$AnimationPlayer.playback_speed = 2
	else:
		#$AnimationPlayer.playback_speed = 1
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# TODO(jfurbina@): logic for shooting
	if Input.is_action_pressed("ui_action1"):
		pass
	
	# Apply movement to player object
	velocity = move_and_slide(velocity, Vector3.UP)
	
func die():
	emit_signal("hit")
	queue_free()
	
func _on_Area_body_entered(body):
	pass # Replace with function body.
