extends CharacterBody3D

signal death

# Character speed in meters per second.
@export var speed: float = 30
@export var fall_acceleration: float = 75
@export var cooldown_time: float = 0.25
@export (PackedScene) var bullet_scene

var timeHandler: Timer
var timer_is_running: bool = false
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
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
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.playback_speed = 2
	else:
		$AnimationPlayer.playback_speed = 1
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	
	# Apply movement to player object
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	velocity = velocity

func process_input_actions():
	if Input.is_action_pressed("ui_action1") and bullet_available():
		var bullet: LittleBall = bullet_scene.instantiate()
		owner.add_child(bullet)
		bullet.transform = $Pivot/Marker3D.global_transform
		bullet.velocity = -bullet.transform.basis.z * bullet.speed
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
