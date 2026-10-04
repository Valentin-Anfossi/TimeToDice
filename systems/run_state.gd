class_name RunState
extends RefCounted

signal changed

@export var duration := 10.0
var time_left := duration
var kept_effect : Array[FaceEffect]
var next_multiplier := 1.0
var max_hp:= 10
var turn := 1
var atk:= 0
var pool: FacePool = DiceGenerator.make_starter_pool()
var ennemy_atk_base := 2
var ennemy_atk_turn := 1
var ennemy_atk := 0

func ennemy_intent() -> int:
	changed.emit()
	return maxi(ennemy_atk_base + (randi_range(-ennemy_atk_turn/2,ennemy_atk_turn)), 1)

var hp := 3:
	set(v):
		hp=v
		changed.emit()

var money := 0:
	set(v):
		money = v
		changed.emit()
		
var shield := 0:
	set(v):
		shield = v
		changed.emit()

var ennemy_hp := 30:
	set(v):
		ennemy_hp = v
		changed.emit()

func tick(delta):
	time_left -= (1 * delta)

func get_progress() -> float:
	if(time_left == 0):
		return 0
	else :
		return (1.0 - (time_left/duration))
		
static func from_level(l: LevelData) -> RunState:
	var r:= RunState.new()
	r.hp = l.player_hp
	return r
