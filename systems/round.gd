extends Node3D

@export var dice_scene: PackedScene
@export var speed_min = .2
@export var speed_max = 1
@export var spacing = 1
@export var ndices = 6

var dices_rolled := 1
var run:= RunState.new()
var dice: Node3D
var faces:Array[DiceFace]
enum State {RUNNING,PAUSED,ENDED}
var state := State.RUNNING
var fail_effect := DamageEffect.new()
var kept_dice: Array[Node3D]

func _ready() -> void:
	start_round()
	pass # Replace with function body.

func start_round() -> void:
	if (state != State.RUNNING):
		return
	faces = DiceGenerator.build()
	dice = dice_scene.instantiate()
	add_child(dice)
	dice.global_position= Vector3(0,0,0)
	dice.setup(faces)
	dice.validated.connect(_on_dice_validated)
	dice.reached_bottom.connect(_on_dice_bottom)
	
func _on_dice_validated(index : int)->void:
	_finish_dice(faces[index].effect)
	
func _on_dice_bottom() -> void:
	_finish_dice(fail_effect)
	
func _finish_dice(effect: FaceEffect) -> void:
	run.kept_effect.append(effect)
	kept_dice.append(dice)
	dice.lock()
	dices_rolled += 1
	var slot := kept_dice.size()
	dice.reparent(%Shelf)
	var tween := create_tween().set_parallel()
	tween.tween_property(dice,"position",Vector3(slot * spacing,0,0),0.3)
	tween.tween_property(dice,"scale",Vector3.ONE * .8, 0.3)
	#effect.apply(run)
	#print("Money=%d HP=%d Progress=%f" %[run.money, run.hp, run.get_progress()])
	#dice.queue_free()
	#if(run.time_left > 0.0 and run.hp > 0 and state == State.RUNNING):
	if(run.hp > 0 and dices_rolled < ndices + 1 and state == State.RUNNING):
		start_round()
	else:
		state = State.ENDED
		_end_run()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		State.RUNNING:
			run.tick(delta)
			if is_instance_valid(dice):
				#dice.fall_speed = lerpf(speed_min, speed_max, run.get_progress())
				dice.fall_speed = lerpf(speed_min,speed_max,float(dices_rolled)/float(ndices))  
		State.PAUSED:
			pass
		State.ENDED:
			pass

func _end_run() ->void:
	state = State.ENDED
	#if is_instance_valid(dice):
		#dice.queue_free()
	for i in run.kept_effect.size():
		var mult:= run.next_multiplier
		run.next_multiplier = 1.0
		var tween := create_tween().set_parallel()
		tween.tween_property(kept_dice[i],"scale",Vector3.ONE *.95,0.1)
		await get_tree().create_timer(0.5).timeout
		run.kept_effect[i].apply(run, mult)
	print("Fin ! Money=%d hp=%d" % [run.money, run.hp])
