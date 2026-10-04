class_name DamageEffect
extends FaceEffect

@export var amount := 1

func apply(run : RunState, mult:= 1.0) -> void:
	run.ennemy_hp -= amount * mult
	
func describe() -> String:
	return "+%d" % amount

func get_color() -> Color:
	return Color.RED

func get_type() -> String:
	return "atk"

func get_texture() -> Texture2D:
	var tex : Texture2D = load("res://assets/Atac.png")
	return tex
