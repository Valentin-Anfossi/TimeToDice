class_name AttackEffect
extends Resource

@export var amount = 1.0

func apply(_run: RunState, mult := 1.0) -> void:
	_run.ennemy_hp -= (amount * mult)

func describe() -> String:
	return "%d"%amount

func get_color() -> Color:
	return Color.DARK_RED

func get_type() -> String:
	return "atk"

func get_texture() -> Texture2D:
	var tex : Texture2D = load("res://assets/Atac.png")
	return tex
