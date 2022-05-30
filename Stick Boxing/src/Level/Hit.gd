extends AnimatedSprite


func _ready():
	$".".play("hit")
	yield($".", "animation_finished")
	queue_free()
