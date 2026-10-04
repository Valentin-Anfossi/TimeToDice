extends Control

var state: RunState

func bind(s: RunState) -> void:
	state = s
	state.changed.connect(_refresh_hud)
	_refresh_hud()

func _refresh_hud() -> void:
	var hp := maxi(state.hp,0)
	%hp_label.text =  str(hp)
	var shield := maxi(state.shield,0)
	%shield_label.text = str(shield)
	%enemyhp_label.text = "Enemy HP :" + str(state.ennemy_hp)
	%enemyatk_label.text = "Next attack " + str(state.ennemy_atk) + " dmg"
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _show_results(won :bool) -> void:
	if(won):
		%victory_label.show()
	else:
		%defeat_label.show()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
