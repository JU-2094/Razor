extends KinematicBody

class_name LittleBall

var timerHandler: Timer
var velocity: Vector3 = Vector3.ZERO
var init: bool = false
export var speed: int = 50
export var lifetime: float = 2

func _ready():
	timerHandler = Timer.new()
	timerHandler.connect("timeout", self, "lifetime_out")
	timerHandler.set_wait_time(lifetime)
	add_child(timerHandler)
	timerHandler.start()
	pass

func set_dir(direction: Vector3):
	look_at(direction, Vector3.UP)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(delta):
	move_and_slide(velocity)

func lifetime_out():
	queue_free()
