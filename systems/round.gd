extends Node3D

@export var dice_scene: PackedScene
@export var speed_min = 1.5
@export var speed_max = 3
@export var spacing = 1.25
@export var ndices = 6
@export var dice_startPosition: Vector3

enum State { FALLING, SCORING, ENEMY_TURN, ENDED, PAUSED }

var game := RunState.new()
var state := State.FALLING
var dice: Node3D
var faces: Array[DiceFace]
var kept_dice: Array[Node3D] = []
var dices_rolled := 0 
var fail_effect := HpEffect.new()


func _ready() -> void:
	fail_effect.amount = -1
	start_round()


func _process(_delta: float) -> void:
	if state == State.FALLING and is_instance_valid(dice) and not dice.locked:
		dice.fall_speed = lerpf(speed_min, speed_max, float(dices_rolled) / float(ndices))



func start_round() -> void:
	for d in kept_dice:
		if is_instance_valid(d):
			d.queue_free()
	kept_dice.clear()
	game.kept_effect.clear()
	game.next_multiplier = 1.0
	dices_rolled = 0
	state = State.FALLING
	print("Round %d | ennemi %d PV | attaque prévue %d | toi %d PV" % [
		game.turn, game.ennemy_hp, game.ennemy_intent(), game.hp])
	start_run()


func _end_round() -> void:
	state = State.SCORING
	await get_tree().create_timer(0.5).timeout
	for i in game.kept_effect.size():
		var mult := game.next_multiplier
		game.next_multiplier = 1.0
		var d := kept_dice[i]
		var tween := create_tween().set_parallel()
		tween.tween_property(d, "scale", Vector3.ZERO, 0.2)
		tween.tween_property(d, "global_position", %Ennemy_Pos.global_position, 0.2)
		game.kept_effect[i].apply(game, mult)
		await get_tree().create_timer(0.5).timeout
		d.queue_free()

	if game.ennemy_hp <= 0:
		_end_game(true)
		return
	if game.hp <= 0:
		_end_game(false)
		return

	state = State.ENEMY_TURN
	await _enemy_attack()
	if game.hp <= 0:
		_end_game(false)
		return

	game.turn += 1
	start_round()


func _enemy_attack() -> void:
	await get_tree().create_timer(0.5).timeout
	var dmg := maxi(0, game.ennemy_intent() - game.shield)
	game.shield = 0
	game.hp -= dmg
	print("L'ennemi frappe : %d dégâts (PV restants : %d)" % [dmg, game.hp])
	await get_tree().create_timer(0.5).timeout


# =============================================================== RUN

func start_run() -> void:
	if state != State.FALLING:
		return
	faces = DiceGenerator.build(game.pool)
	dice = dice_scene.instantiate()
	add_child(dice)
	dice.global_position = dice_startPosition
	dice.setup(faces)
	dice.validated.connect(_on_dice_validated)
	dice.reached_bottom.connect(_on_dice_bottom)


func _on_dice_validated(index: int) -> void:
	_end_run(faces[index].effect)


func _on_dice_bottom() -> void:
	_end_run(fail_effect)

func _end_run(effect: FaceEffect) -> void:
	if state != State.FALLING or dice.locked:
		return
	dice.lock()
	dices_rolled += 1

# On perd juste le des
	if effect == fail_effect:
		dice.queue_free()
	else:
		game.kept_effect.append(effect)
		kept_dice.append(dice)
		_move_to_shelf(dice, kept_dice.size() - 1)

	if dices_rolled >= ndices:
		_end_round()
	else:
		start_run()


func _move_to_shelf(d: Node3D, slot: int) -> void:
	d.reparent(%Shelf)
	var x : float= (slot - (ndices - 1) / 2.0) * spacing
	var tween := create_tween().set_parallel()
	tween.tween_property(d, "position", Vector3(x, 0, 0), 0.3)
	tween.tween_property(d, "scale", Vector3.ONE, 0.3)


func _end_game(won: bool) -> void:
	state = State.ENDED
	_print_result(won)


func _print_result(won: bool) -> void:
	print("===== %s =====" % ("Victory !" if won else "boo u suck"))
	print("Rounds : %d | Money=%d | PV=%d | PV ennemi=%d" % [
		game.turn, game.money, game.hp, game.ennemy_hp])
