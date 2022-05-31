extends TextureButton

func _ready():
	pass


func _on_Player1_lostFight():
	show()


func _on_Player2_lostFight():
	show()


func _on_Rematch_pressed():
	get_tree().change_scene("res://src/Level/game.tscn")
