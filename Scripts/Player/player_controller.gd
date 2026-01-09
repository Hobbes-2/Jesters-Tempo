extends Node2D

@export var key_name = ""

@onready var left_arrow: Node2D = $KeyListener3
@onready var right_arrow: Node2D = $KeyListener
@onready var top_arrow: Node2D = $KeyListener4
@onready var bottom_arrow: Node2D = $KeyListener2

signal leftClick
signal rightClick
signal upClick
signal downClick

var falling_key = load("res://Scenes/falling_key.tscn")
var falling_key_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		if left_arrow.entered == true:
			print("Left hit!")
			leftClick.emit()
		else:
			print("Left missed!")
	if Input.is_action_just_pressed("Right"):
		if right_arrow.entered == true:
			print("Right hit!")
			rightClick.emit()
		else:
			print("Right missed!")
	if Input.is_action_just_pressed("Up"):
		if top_arrow.entered == true:
			print("Top hit!")
			upClick.emit()
		else:
			print("Top missed!")
	if Input.is_action_just_pressed("Down"):
		if bottom_arrow.entered == true:
			print("Bottom hit!")
			downClick.emit()
		else:
			print("Bottom missed!")

	#if Input.is_action_just_pressed("SpawnDown"):
		#CreateFallingKey(bottom_arrow)
	#if Input.is_action_just_pressed("SpawnUp"):
		#CreateFallingKey(top_arrow)
	#if Input.is_action_just_pressed("SpawnLeft"):
		#CreateFallingKey(left_arrow)
	#if Input.is_action_just_pressed("SpawnRight"):
		#CreateFallingKey(right_arrow)
#
	#if falling_key_queue.size > 0:
		#if falling_key_queue.front().has_passed:
			#falling_key_queue.pop_front()
			#print("Popped")
#
#func CreateFallingKey(arrow : Node2D):
	#var fk_inst = falling_key.instantiate()
	#var direction = arrow.name.substr(0, str(arrow.name).length() - 2).to_lower()
	#print("dir is ", direction)
	#fk_inst.animation = direction
	#get_tree().get_root().call_deferred("add_child", fk_inst)
	#fk_inst.Setup(arrow.position.y)
	#
	#falling_key_queue.push_back(fk_inst)
#
#
#func _on_random_timer_timeout() -> void:
	#CreateFallingKey
