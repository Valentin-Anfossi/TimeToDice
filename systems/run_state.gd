class_name RunState
extends RefCounted

signal changed

@export var duration := 10.0
var time_left := duration
var kept_effect : Array[FaceEffect]
var next_multiplier := 1.0
var max_hp:= 10
var shield := 0
var ennemy_hp := 30
var turn := 1
var atk:= 0
var pool: FacePool = DiceGenerator.make_starter_pool()

func ennemy_intent() -> int:
	return 4 + turn * 2

var hp := 3:
	set(v):
		hp=v
		changed.emit()

var money := 0:
	set(v):
		money = v
		changed.emit()

func tick(delta):
	time_left -= (1 * delta)

func get_progress() -> float:
	if(time_left == 0):
		return 0
	else :
		return (1.0 - (time_left/duration))
