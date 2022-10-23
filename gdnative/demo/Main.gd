extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var memo=[1,1]
var counter=0
# Called when the node enters the scene tree for the first time.
func _ready():
	print(memov2(10))
	print(counter)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func memov1(number):
	if number==1:
		return memo[0]
	if number==2:
		return memo[1]
	else:
		for i in range(2,number):
			memo.append(memo[i-1]+memo[i-2])
		return memo[-1]

func memov2(number):
	counter+=1
	if number==1:
		return memo[0]
	elif number==2:
		return memo[1]
	else:
		memo.append(memov2(number-1)+memov2(number-1))
		return memo[number-1]
