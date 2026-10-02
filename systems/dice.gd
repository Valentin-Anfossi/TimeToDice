extends Node3D

signal validated(face_index: int)
signal reached_bottom()

var ROTATION_TIME = 0.1;
const NORMALS = [Vector3.UP,Vector3.DOWN,Vector3.LEFT,Vector3.RIGHT,Vector3.FORWARD,Vector3.BACK]
var input_enabled := true;
var is_rotating := false;
var _tween: Tween
var _start_basis: Basis
var has_reached_bottom := false
var locked := false
@export var fall_speed := .1
@export var bottom_y := -4.5

@onready var labels := $Faces.get_children()

func setup(faces: Array[DiceFace])->void:
	for i in labels.size():
		labels[i].text = faces[i].get_text()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_face_towards(dir: Vector3) -> int:
	var best := 0
	var best_dot := -INF
	for i in NORMALS.size():
		var d: float = (global_transform.basis * NORMALS[i]).dot(dir)
		if d > best_dot:
			best_dot = d
			best = i
	return best

func _rotate_quarter(axis: Vector3, degrees: float) -> void:
	is_rotating = true
	_start_basis = basis
	
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_method(_apply_rotation.bind(axis),0.0,deg_to_rad(degrees),ROTATION_TIME)
	_tween.finished.connect(_on_rotation_finished)
	
func _apply_rotation(angle: float, axis: Vector3) -> void:
	basis = Basis(axis,angle) * _start_basis
	
func _on_rotation_finished() -> void:
	basis= basis.orthonormalized()
	is_rotating = false

func lock():
	input_enabled = false
	fall_speed = 0
	locked = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= fall_speed * delta;
	if position.y < bottom_y and has_reached_bottom == false:
		print("bottom")
		reached_bottom.emit()
		has_reached_bottom = true

	if not input_enabled or is_rotating:
		return
	
	if (Input.is_action_just_pressed("RotateLeft")):
		_rotate_quarter(Vector3.BACK,90)
	elif (Input.is_action_just_pressed("RotateRight")):
		_rotate_quarter(Vector3.BACK,-90)
	elif (Input.is_action_just_pressed("RotateDown")):
		_rotate_quarter(Vector3.RIGHT,90)
	elif (Input.is_action_just_pressed("RotateUp")):
		_rotate_quarter(Vector3.RIGHT,-90)
		
	if (Input.is_action_just_pressed("Validate")):
		validated.emit(get_face_towards(Vector3.UP))
	pass
