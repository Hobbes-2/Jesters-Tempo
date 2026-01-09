extends Node2D

@export var key_name = ""

@onready var left_arrow: Node2D = $LeftKL
@onready var right_arrow: Node2D = $RightKL
@onready var top_arrow: Node2D = $TopKL
@onready var bottom_arrow: Node2D = $BottomKL

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
		else:
			print("Right missed!")
	if Input.is_action_just_pressed("Up"):
		if top_arrow.entered == true:
			print("Top hit!")
		else:
			print("Top missed!")
	if Input.is_action_just_pressed("Down"):
		if bottom_arrow.entered == true:
			print("Bottom hit!")
		else:
			print("Bottom missed!")

	if Input.is_action_just_pressed("SpawnDown"):
		CreateFallingKey("bottom")

func CreateFallingKey(pos : String):
	var which = pos + "_arrow"
	var fk_inst = falling_key.instantiate()
	get_tree().get_root().call_deferred("add_child", fk_inst)
	fk_inst.Setup(which.position.y)
	
	falling_key_queue.push_back(fk_inst)
