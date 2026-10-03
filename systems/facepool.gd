class_name FacePool
extends Resource

@export var entries : Array[PoolEntry] = []

func add(effect : FaceEffect, weight := 1.0) -> void:
	var entry := PoolEntry.new()
	entry.effect = effect
	entry.weight = weight
	entries.append(entry)
	
func remove(index:int) -> void:
	entries.remove_at(index)
	
func total_weight() -> float :
	var total := 0.0
	for e in entries:
		total += e.weight
	return total
	
func pick_effect() -> FaceEffect:
	var r := randf() * total_weight()
	for e in entries:
		if e.weight <= 0.0:
			continue
		r -= e.weight
		if r <= 0.0:
			return e.effect.duplicate()
	return entries.back().effect.duplicate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
