extends KinematicBody

signal hit

# Character speed in meters per second.
export var speed: float = 30
export var fall_acceleration: float = 75

var timeHandler: Timer
var timer_is_running: bool = false
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var bullet_scene = preload("res://objects/scenes/little_ball.tscn")
onready var player_vars = get_node("/root/PlayerData")
func _ready():
	set_bullet()

func _process(delta):
	process_input_actions()

func _physics_process(delta):
	process_input_movement(delta)

func set_bullet():
	timeHandler = Timer.new()
	timeHandler.set_wait_time(0.5)
	timeHandler.set_one_shot(true)
	timeHandler.connect("timeout", self, "timeout_fire")
	add_child(timeHandler)
	
func bullet_available():
	if player_vars.items["bullets"]<=0:
		#print("out of bullets")
		return false
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
		var bullet: LittleBall = bullet_scene.instance()
		bullet.set_dir(lastDirection)
		add_child(bullet)
		if player_vars.items["bullets"] > 0:
			player_vars.items["bullets"]=player_vars.items["bullets"] - 1

func die():
	emit_signal("hit")
	queue_free()

func _on_AreaPlayer_body_entered(body):
	#print(body.get_name())
	pass # Replace with function body.

func _on_AreaPlayer_area_entered(area):
	#print(area.get_name())
	pass # Replace with function body.

func timeout_fire():
	timer_is_running = false
