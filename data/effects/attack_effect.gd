class_name AttackEffect
extends Resource

@export var amount = 1.0

func apply(_run: RunState, mult := 1.0) -> void:
	_run.ennemy_hp -= (amount * mult)

func describe() -> String:
	return "%d ATK"%amount

func get_color() -> Color:
	return Color.DARK_RED
