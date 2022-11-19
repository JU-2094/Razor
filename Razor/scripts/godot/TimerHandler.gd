extends Timer

class_name TimerHandler

var timeHandler: Timer
var is_running: bool = false 

# ERROR note: The idea is to abstract the Timer logic. 
# However, the callback is never called checked the parent or this instance

func _init(timeout: float,parent: Node):
	timeHandler = Timer.new()
	timeHandler.set_wait_time(timeout)
	parent.add_child(timeHandler)

func connect_timeout(parent: Node, cbk: String, args: Array = []):
	timeHandler.connect("timeout",Callable(parent,cbk).bind(args))

func set_one_shot(enable: bool):
	timeHandler.set_one_shot(enable)

func start_clock():
	is_running = true
	timeHandler.start()

func handler_cbk():
	is_running = false
	print('timeout callback')

