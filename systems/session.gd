extends Node
# AUTOLOAD

var current_level: LevelData
var menu_path := ""

func start_level(level: LevelData, game_scene: PackedScene) -> void:
	current_level = level
	get_tree().change_scene_to_packed(game_scene)
	
func back_to_menu() -> void:
	current_level = null
	if menu_path == "":
		print("Menu path erro")
		return
	get_tree().change_scene_to_file(menu_path)
	
func retry() -> void:
	get_tree().reload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
