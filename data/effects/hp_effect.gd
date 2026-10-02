class_name HpEffect
extends FaceEffect

@export var amount := 1

func apply(run : RunState) -> void:
	run.hp += amount
	
func describe() -> String:
	return "+%d hp" % amount
