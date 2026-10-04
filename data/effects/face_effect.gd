class_name FaceEffect
extends Resource

func apply(_run: RunState, mult := 1.0) -> void:
	pass

func describe() -> String:
	return ""

func get_color() -> Color:
	return Color.WHITE

func get_texture() -> Texture2D:
	return PlaceholderTexture2D.new()

func get_type() -> String:
	return ""
