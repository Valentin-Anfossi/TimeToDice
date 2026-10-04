class_name MultiplierEffect
extends FaceEffect

@export var amount := 2.0

func apply(run: RunState, mult:= 1.0) -> void:
	run.next_multiplier = amount * mult
	
func describe() -> String:
	return "x%d" % amount

func get_color() -> Color:
	return Color.WEB_PURPLE
	
func get_type() -> String:
	return ""
