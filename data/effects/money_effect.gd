class_name MoneyEffect
extends FaceEffect

@export var amount := 1

func apply(_run: RunState, mult := 1.0) -> void:
	_run.money += amount * mult
	
func describe() -> String:
	return "%+d monies" % amount
