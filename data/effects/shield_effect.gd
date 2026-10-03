class_name ShieldEffect
extends FaceEffect

@export var amount = 1.0

func apply(_run: RunState, mult := 1.0) -> void:
	_run.shield += (amount * mult)

func describe() -> String:
	return "+%d Shield"%amount

func get_color() -> Color:
	return Color.DARK_RED
