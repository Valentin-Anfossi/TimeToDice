class_name DiceFace
extends Resource

@export var effect: FaceEffect

func get_text() -> String:
	return effect.describe()
