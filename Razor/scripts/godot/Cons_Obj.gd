extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var obj = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(obj)
	pass # Replace with function body.

func _on_Spatial_body_entered(body):
	if body.get_name()== "Player":
		queue_free()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
