extends KinematicBody

class_name LittleBall

var position: Position3D
var timerHandler: Timer
var direction: Vector3
var velocity: Vector3
var init: bool = false
export var speed: int = 50
export var lifetime: float = 1

func _ready():
	timerHandler = Timer.new()
	timerHandler.connect("timeout", self, "lifetime_out")
	timerHandler.set_wait_time(lifetime)
	add_child(timerHandler)
	timerHandler.start()

func set_dir(dir):
	direction = dir
	look_at(translation + direction, Vector3.UP)

func _physics_process(delta):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity = move_and_slide(velocity, Vector3.UP)
	

func add_instance( \
		owner: Node, bulletResource: Resource, pos: Position3D, direction: Vector3):
	var bullet = bulletResource.instance()
	bullet.set_dir(direction)
	owner.add_child(bullet)

func lifetime_out():
	queue_free()
