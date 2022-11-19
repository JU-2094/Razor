extends StaticBody3D

signal notify(body)

var bullet_scene  = preload("res://objects/scenes/little_ball.tscn")
var timeHandler: Timer
var timer_is_running: bool = false

func _ready():
	set_bullet()
	
	
func set_bullet():
	timeHandler = Timer.new()
	timeHandler.set_wait_time(0.5)
	timeHandler.set_one_shot(true)
	timeHandler.connect("timeout",Callable(self,"cooldown_fire"))
	add_child(timeHandler)
	
func _process(delta):
	if bullet_available():
		aim_and_shoot()

func cooldown_fire():
	timer_is_running = false

func bullet_available():
	if timer_is_running:
		return false
	timer_is_running = true
	timeHandler.start()
	return true

func aim_and_shoot():
	var bullet: LittleBall = bullet_scene.instantiate()
	
	var target = get_parent().get_node("Player") \
		.global_transform.origin
	
	# LINE COMMENTED FOR TESTING, so is not attacking all time
	owner.add_child(bullet)
	bullet.set_scale(Vector3(2,2,2))
	bullet.transform = $Marker3D.global_transform
	bullet.speed = 50
	bullet.connect("bullet_hit",Callable(self,"process_hit"))
	var dir = (target - bullet.global_transform.origin).normalized()
	bullet.velocity = dir * bullet.speed
	
func process_hit(position, target):
	emit_signal("notify", target)
