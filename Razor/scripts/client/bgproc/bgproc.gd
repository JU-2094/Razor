extends Node

var BGPROC_TIMEOUT = 0
var BGPROC_INTRRPT = 1
var register = {}
var mthread
var tthread = {}
var lck = Mutex.new()
var gctx

func bg_init(ctx):
	register.clear()
	tthread.clear()
	mthread = Thread.new()
	mthread.start(Callable(self,"_mainth"))
	gctx = ctx

func bg_chk(ctx):
	if not mthread.is_active():
		bg_init(ctx)

func bg_kill():
	mthread.free()

func _mainth(argv):
	var clock = 0
	while(1):
		for reg in register.values():
			if reg[1]==BGPROC_TIMEOUT and (clock%reg[2])==0 and not tthread.has(reg[0]):
				# execute callback in other thread
				var cbkthread = Thread.new()
				# start returns status OK or an error
				tthread[reg[0]] = cbkthread.start(self, 
									"_crtth", [reg[0], reg[3], null])
		clock = (clock+1) % 50000;

func add_cts(ctx, pfun, reg, flg=BGPROC_TIMEOUT, timeout=100):
	var rfun = funcref(ctx, pfun)
	register[reg] = [reg, flg, timeout, rfun]

func del_cts(reg):
	register.erase(reg)

func call_int(ctx, pfun, args):	 
	var cbkth = Thread.new()
	var rfun = funcref(ctx, pfun)
	cbkth.start(Callable(self,'_crtth').bind([null, rfun, args]))

func _crtth(args):
	args[1].call_func(args[2])
	if (args[0] != null):
		tthread.erase(args[0])

