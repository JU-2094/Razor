extends Node2D

export var cooldown_time: float = 0.25
export (PackedScene) var bullet_scene
export (NodePath) var instance_position

var timeHandler: Timer
var timer_is_running: bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player_vars = get_node("/root/PlayerData")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_bullet()
	pass # Replace with function body.
func _process(delta):
	shoot_process()
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

func cooldown_fire():
	timer_is_running = false

func shoot_process():
	if Input.is_action_pressed("ui_action1") and bullet_available():
		var bullet = bullet_scene.instance()
		get_parent().owner.add_child(bullet)
		var shoot_pivot = get_node(instance_position)
		
		bullet.global_translation = shoot_pivot.global_translation
		var temp_velocity = bullet.transform.basis.z * bullet.speed
		bullet.velocity = temp_velocity.rotated(Vector3.UP, get_parent().rotation.y)
		player_vars.items["bullets"] = player_vars.items["bullets"] - 1
