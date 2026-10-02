class_name MoneyEffect
extends FaceEffect

@export var amount := 10

func apply(run: RunState) -> void:
	run.money += amount
	
func describe() -> String:
	return "%+d monies" % amount
