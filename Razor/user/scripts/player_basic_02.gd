extends KinematicBody

signal death

# Character speed in meters per second.
export (float) var speed: float = 30
export (float) var rotation_speed: float = 1.5
export (float) var cooldown_time: float = 0.25
export (PackedScene) var bullet_scene

var timeHandler: Timer
var timer_is_running: bool = false
var lastDirection: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO
var rotation_dir: float = 0

# var bullet_scene = preload("res://objects/scenes/little_ball.tscn")
onready var player_vars = get_node("/root/PlayerData")

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
	timeHandler.connect("timeout", self, "cooldown_fire")
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
	
	
	rotation_dir = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	
	# rotate_y(rad2deg(rotation_dir * 2))
	if Input.action_press("ui_up"):
		engine_force = speed
	else:
		engine_force = 0
	
	if Input.action_press("ui_down"):
		engine_force = -speed
			
	if engine_force != 0:
		$AnimationPlayer.playback_speed = 2
	else:
		$AnimationPlayer.playback_speed = 1
	
	# Apply movement to player object
	
	
func process_input_actions():
	if Input.is_action_pressed("ui_action1") and bullet_available():
		var bullet: LittleBall = bullet_scene.instance()
		owner.add_child(bullet)
		bullet.transform = $Pivot/Position3D.global_transform
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
