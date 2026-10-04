class_name LevelData
extends Resource

@export var name := "Level 1"
#@export_multiline var story := ""
@export var scene : PackedScene

@export_group ("Ennemi")
@export var enemy_hp := 10
@export var enemy_base_attack := 1
@export var enemy_atkround := 1

@export_group ("Player")
@export var player_hp := 10

@export_group("Rounds")
@export var ndices := 3
@export var speed_min := .5
@export var speed_max := 1

@export_group ("Dices")
@export var extra_pool : Array[PoolEntry] = []
