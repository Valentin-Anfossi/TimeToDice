extends Control

@export var game_scene: PackedScene
@export var levels: Array[LevelData] = []

@onready var buttons : VBoxContainer = %Buttons

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Session.menu_path = scene_file_path
	print(scene_file_path)
	for level in levels:
		var b := Button.new()
		b.text = level.name
		b.pressed.connect(_on_level_press.bind(level))
		buttons.add_child(b)
	pass # Replace with function body.

func _on_level_press(level : LevelData) -> void:
	Session.start_level(level, level.scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
