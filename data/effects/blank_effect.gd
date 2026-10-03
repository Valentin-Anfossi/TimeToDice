class_name BlankEffect
extends FaceEffect

func apply(run : RunState, mult:= 1.0) -> void:
	pass
	
func describe() -> String:
	return "Blank(-1hp)"

func get_color() -> Color:
	return Color.BLACK
