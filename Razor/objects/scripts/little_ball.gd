extends Area

class_name LittleBall

signal exploded

var timerHandler: Timer
var velocity: Vector3 = Vector3.ZERO
var init: bool = false
export var speed: int = 100
export var lifetime: float = 2

func _ready():
	timerHandler = Timer.new()
	timerHandler.connect("timeout", self, "lifetime_out")
	timerHandler.set_wait_time(lifetime)
	add_child(timerHandler)
	timerHandler.start()

func set_dir(direction: Vector3):
	look_at(direction, Vector3.UP)
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(delta):
	velocity += Vector3.FORWARD * delta
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta

func lifetime_out():
	queue_free()

func _on_Shell_body_entered(body):
	print("on_Shell_body_entered  SIGNAL")
	emit_signal("exploded", transform.origin)
	queue_free()
