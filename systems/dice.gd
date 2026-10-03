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
@export var bottom_y := -.5
var mat : StandardMaterial3D = null
var glow : StandardMaterial3D = null
var _faces : Array[DiceFace]
@onready var labels := $Faces.get_children()

func setup(faces: Array[DiceFace])->void:
	for i in labels.size():
		_faces = faces
		labels[i].text = faces[i].get_text()
		var billibord := Sprite3D.new()
		billibord.global_transform = labels[i].global_transform
		billibord.texture = NoiseTexture2D.new()
		
		#glow = %MeshInstance3D.get_active_material(1).duplicate()
		#mat = %MeshInstance3D.get_active_material(0).duplicate()
		#%MeshInstance3D.set_surface_override_material(0,mat)
		#%MeshInstanced3D.set_surface_override_material(1,glow)
		_update_mat(5)
		#_rotate_label(labels[i],Vector3.BACK)

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
	
func _update_mat(face : int) -> void:
	var tween := create_tween()
	tween.tween_property(glow,"emission",_faces[face].effect.get_color(),0.15)
	
func _on_rotation_finished() -> void:
	basis= basis.orthonormalized()
	var cam:= get_viewport().get_camera_3d()
	var i := get_face_towards(cam.global_basis.z)
	_rotate_label(labels[i], cam.global_basis.y)
	_update_mat(i)
	is_rotating = false

func lock():
	input_enabled = false
	fall_speed = 0
	locked = true
	
func _rotate_label(label :Label3D, view_up:Vector3) -> void:
	var n := label.global_basis.z.normalized()
	var target := (view_up - n * view_up.dot(n)).normalized()  
	var angle := label.global_basis.y.normalized().signed_angle_to(target,n)
	var tween := create_tween()
	#tween.tween_property(label,"rotation_degrees",angle,.1)
	label.rotate_object_local(Vector3.BACK,angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= fall_speed * delta;
	if position.y < bottom_y and has_reached_bottom == false:
		print("bottom")
		reached_bottom.emit()
		has_reached_bottom = true
		#var mat : StandardMaterial3D = %MeshInstance3D.get_active_material(0)
		#mat.albedo_color = Color(0.089, 0.089, 0.089, 1.0)

	if not input_enabled or is_rotating:
		return
	
	if (Input.is_action_just_pressed("RotateLeft")):
		_rotate_quarter(Vector3.UP,90)
	elif (Input.is_action_just_pressed("RotateRight")):
		_rotate_quarter(Vector3.UP,-90)
	elif (Input.is_action_just_pressed("RotateDown")):
		_rotate_quarter(Vector3.LEFT,90)
	elif (Input.is_action_just_pressed("RotateUp")):
		_rotate_quarter(Vector3.LEFT,-90)
		
	if (Input.is_action_just_pressed("Validate")):
		validated.emit(get_face_towards(Vector3.BACK))
	pass
