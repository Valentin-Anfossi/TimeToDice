class_name HpEffect
extends FaceEffect

@export var amount := 1

func apply(run : RunState, mult:= 1.0) -> void:
	run.hp += amount * mult
	
func describe() -> String:
	return "+%d" % amount

func get_color() -> Color:
	return Color.GREEN
	
func get_texture() -> Texture2D:
	var texture = load("res://assets/Coeur p.png")
	return texture

func get_type() -> String:
	return "status"
