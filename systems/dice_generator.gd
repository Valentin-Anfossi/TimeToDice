class_name DiceGenerator
extends RefCounted

#//Declaration de la starter pool (face + poids)
static func make_starter_pool() -> FacePool:
	var pool:= FacePool.new()
	pool.add(_make_hp(2), 0.25)
	pool.add(_make_shield(5),0.14)
	pool.add(_make_dmg(1),1)
	pool.add(_make_dmg(2),0.6)
	pool.add(_make_dmg(4),0.07)
	pool.add(_make_multiply(2),0.15)
	pool.add(_make_blank(),0.10)
	return pool

static func _make_blank() -> FaceEffect:
	var e:= BlankEffect.new()
	return e

static func _make_shield(amount : int) -> FaceEffect:
	var e:= ShieldEffect.new()
	e.amount = amount
	return e

static func _make_dmg(amount : int) -> FaceEffect:
	var e:= DamageEffect.new()
	e.amount = amount
	return e

static func _make_money(amount : int) -> FaceEffect:
	var e:= MoneyEffect.new()
	e.amount = amount
	return e

static func _make_hp(amount : int) -> FaceEffect:
	var e:= HpEffect.new()
	e.amount = amount
	return e

static func _make_multiply(amount : int) -> FaceEffect:
	var e:= MultiplierEffect.new()
	e.amount = amount
	return e

static func build(pool : FacePool, faces_count:= 6) -> Array[DiceFace]:
	#var makers: Array[Callable] = [_make_money,_make_hp,_make_multiply]
	var faces: Array[DiceFace] = []
	for i in faces_count:
		var face := DiceFace.new()
		if i == 5 :
			face.effect = BlankEffect.new()
		else :
			face.effect = pool.pick_effect()
		faces.append(face)
	return faces
		
