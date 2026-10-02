class_name DamageEffect
extends FaceEffect

@export var amount := 1

func apply(run : RunState, mult:= 1.0) -> void:
	run.hp -= amount
	
func describe() -> String:
	return "+%d hp" % amount
