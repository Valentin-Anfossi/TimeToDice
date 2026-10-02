class_name DiceGenerator
extends RefCounted

static func _make_money() -> FaceEffect:
	var e:= MoneyEffect.new()
	e.amount = [1,1,2].pick_random()
	return e

static func _make_hp() -> FaceEffect:
	var e:= HpEffect.new()
	e.amount = [1,1,2].pick_random()
	return e

static func _make_multiply() -> FaceEffect:
	var e:= MultiplierEffect.new()
	e.amount = 2.0
	return e

static func build(faces_count:= 6) -> Array[DiceFace]:
	var makers: Array[Callable] = [_make_money,_make_hp,_make_multiply]
	var faces: Array[DiceFace] = []
	for i in faces_count:
		var face := DiceFace.new()
		if i == 0 :
			face.effect = BlankEffect.new()
		else :
			face.effect = makers.pick_random().call()
		faces.append(face)
	return faces
		
