extends CharacterBody3D

signal death

# Character speed in meters per second.
@export (float) var speed: float = 30
@export (float) var angular_acceleration : float = 3
@export var fall_acceleration: float = 75
@export (float) var cooldown_time: float = 0.25
@export (PackedScene) var bullet_scene

var timeHandler: Timer
var timer_is_running: bool = false
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.FORWARD

# var bullet_scene = preload("res://objects/scenes/little_ball.tscn")
@onready var player_vars = get_node("/root/PlayerData")

func _ready():
	set_bullet()

func _process(delta):
	process_input_actions()

func _physics_process(delta):
	process_input_movement(delta)

func set_bullet():
	timeHandler = Timer.new()
	timeHandler.set_wait_time(cooldown_time)
	timeHandler.set_one_shot(true)
	timeHandler.connect("timeout",Callable(self,"cooldown_fire"))
	add_child(timeHandler)
	
func bullet_available():
	if player_vars.items["bullets"] <= 0:
		return false
	if timer_is_running:
		return false
	timer_is_running = true
	timeHandler.start()
	return true

func process_input_movement(delta):
	var rot_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity = Vector3(
		0, 
		-fall_acceleration * delta, 
		Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")).normalized() 
	
	if rot_dir != 0:
		rotation.y = lerp_angle(rotation.y, rotation.y - (PI/2 * rot_dir), delta * angular_acceleration)
	if velocity != Vector3.ZERO:
		$AnimationPlayer.playback_speed = 2
	else:
		$AnimationPlayer.playback_speed = 1
	
	# Apply movement to player object
	set_velocity(velocity.rotated(Vector3.UP, rotation.y) * speed)
	set_up_direction(Vector3.UP)
	move_and_slide()
	velocity = velocity
	
func process_input_actions():
	if Input.is_action_pressed("ui_action1") and bullet_available():
		var bullet: LittleBall = bullet_scene.instantiate()
		owner.add_child(bullet)
		bullet.transform = $Pivot/Marker3D.global_transform
		bullet.velocity = bullet.transform.basis.z * bullet.speed
		player_vars.items["bullets"] = player_vars.items["bullets"] - 1

func die():
	emit_signal("death")
	#queue_free()
	visible = false

func _on_AreaPlayer_body_entered(body):
	#print(body.get_name())
	pass # Replace with function body.

func _on_AreaPlayer_area_entered(area):
	#print(area.get_name())
	pass # Replace with function body.

func cooldown_fire():
	timer_is_running = false

func decrease_health():
	player_vars.stats["health"] = player_vars.stats["health"] - 20
	if (player_vars.stats["health"] <= 0):
		die()
