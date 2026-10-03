class_name DamageEffect
extends FaceEffect

@export var amount := 1

func apply(run : RunState, mult:= 1.0) -> void:
	run.ennemy_hp -= amount * mult
	
func describe() -> String:
	return "+%d Atk" % amount

func get_color() -> Color:
	return Color.RED
