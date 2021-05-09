extends KinematicBody

signal hit

# Character speed in meters per second.
export var speed: float = 30
export var fall_acceleration: float = 75

var resourceBullet: Resource = preload("res://objects/scenes/little_ball.tscn")
var timeHandler: Timer
var timer_is_running: bool = false
var bulletNode: LittleBall
var lastDirection: Vector3 = Vector3.ZERO

var velocity: Vector3 = Vector3.ZERO

func _ready():
	set_bullet()

func _physics_process(delta):
	process_input_movement(delta)
	process_input_actions()

func set_bullet():
	bulletNode = LittleBall.new()
	timeHandler = Timer.new()
	timeHandler.set_wait_time(0.5)
	timeHandler.set_one_shot(true)
	timeHandler.connect("timeout", self, "timeout_fire")
	add_child(timeHandler)
	
func bullet_available():
	if timer_is_running:
		return false
	timer_is_running = true
	timeHandler.start()
	return true

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
		lastDirection = direction
		print(lastDirection)
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
	if Input.is_action_pressed("ui_action1") and bullet_available():
		bulletNode.add_instance( \
			self, resourceBullet, $Pivot/Position3D, lastDirection)
		

func die():
	emit_signal("hit")
	queue_free()

func _on_AreaPlayer_body_entered(body):
	# print(body.get_name())
	pass # Replace with function body.

func _on_AreaPlayer_area_entered(area):
	# print(area.get_name())
	pass # Replace with function body.

func timeout_fire():
	timer_is_running = false
