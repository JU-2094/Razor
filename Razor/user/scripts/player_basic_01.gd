extends KinematicBody

signal hit

# Character speed in meters per second.
export var speed: float = 30
export var fall_acceleration: float = 75

onready var bulletResource: Resource = preload('res://objects/scenes/little_ball.tscn')

var velocity: Vector3 = Vector3.ZERO
var timerHandler: Timer = Timer.new()

func _ready():
	add_timer()

func _physics_process(delta):
	process_input_movement(delta)
	process_input_actions()

func process_input_movement(delta):
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
	velocity.y -= fall_acceleration * delta
	
	# Apply movement to player object
	velocity = move_and_slide(velocity, Vector3.UP)
	
func process_input_actions():
	if Input.is_action_pressed("ui_action1") and not timerHandler.is_stopped():
		var b = bulletResource.instance()
		owner.add_child(b)
		b.transform = $Pivot/Position3D.global_transform
		b.velocity = -b.transform.basis.z * b.muzzle_velocity
		timerHandler.start()

func add_timer():
	timerHandler.set_wait_time(0.5)
	timerHandler.set_one_shot(true)
	add_child(timerHandler)
	timerHandler.start()


func die():
	emit_signal("hit")
	queue_free()


func _on_AreaPlayer_body_entered(body):
	print(body.get_name())
	pass # Replace with function body.


func _on_AreaPlayer_area_entered(area):
	print(area.get_name())
	pass # Replace with function body.
