class_name MoneyEffect
extends FaceEffect

@export var amount := 1

func apply(_run: RunState, mult := 1.0) -> void:
	_run.money += amount * mult
	
func describe() -> String:
	return "%d" % amount

func get_color() -> Color:
	return Color.YELLOW
	
func get_texture() -> Texture2D:
	var tex : Texture2D = load("res://assets/Piece.png")
	return tex

func get_type() -> String:
	return "bag"
