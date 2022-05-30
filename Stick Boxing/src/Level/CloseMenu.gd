extends TextureButton

var buttonPressed = false

func _ready():
	pass


func _on_Close_pressed():
	get_tree().quit()


func _on_Play_pressed():
	disabled = true
	buttonPressed = true
