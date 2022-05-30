extends TextureButton

var buttonPressed = false

func _ready():
	pass


func _on_Play_pressed():
	disabled = true
	buttonPressed = true
	get_node("../AnimationMenu").play("menu")
	get_node("../Timer").start()
	get_node("../Black").visible = true


func _on_Play_mouse_entered():
	if !buttonPressed:
		return
		

func _on_Timer_timeout():
	get_tree().change_scene("res://src/Level/game.tscn")
