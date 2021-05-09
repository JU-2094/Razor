extends 'res:://addons/gut/test.gd'

class TestTimerHandler:
	extends 'res:://addons/gut/test.gd'
	
	var timer = load('res:://generic/TimerHandler.gd')
	
	func callback():
		return 1
	
	func callback_with_args(val):
		return val
		
	func test_addCallback():
		pass
	
	
