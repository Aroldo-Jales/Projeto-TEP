extends KinematicBody2D

# TROCAR RUNNING PARA WALKING
# TIRAR ROLLING 
# TIRAR FALL 
# TIRAR JUMPING

export (int) var speed = 200
export (int) var jump_speed = -180
export (int) var gravity = 500

var velocity = Vector2.ZERO

enum state { RUNNING, WALKING, IDLE, ATTACK, JUMP, FALL}

var player_state = state.IDLE

func get_input():
	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if(dir != 0):
		velocity.x = dir * speed
		print(velocity)
	else:
		velocity.x = 0

func update_animation(): 
	match(player_state):
		state.IDLE:
			$AnimationPlayer.play("Idle")
		state.RUNNING:
			$AnimationPlayer.play("Running")
		state.JUMP:
			$AnimationPlayer.play("Jump")
		state.FALL:
			$AnimationPlayer.play("Fall")
		state.ATTACK:
			$AnimationPlayer.play("Attack")
			yield($AnimationPlayer, "animation_finished")
			player_state = state.IDLE
			
func _physics_process(delta):
	if player_state != state.ATTACK:
		get_input()
		if velocity.x == 0:
			player_state = state.IDLE
		elif velocity.x != 0:
			if Input.get_action_strength("boost"): # TESTES
				player_state = state.RUNNING
				velocity.x = velocity.x * 3
			player_state = state.RUNNING
		
		if is_on_floor(): # PARA PULAR
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = jump_speed
				player_state = state.JUMP
			if Input.is_action_just_pressed("attack"):
				velocity.x = 0
				player_state = state.ATTACK
				
		
	if not is_on_floor(): # PARA VERIFICAR SE ESTÁ CAINDO
		if velocity.y < 0:
			player_state = state.JUMP
		else:
			player_state = state.FALL
		
	if Input.is_action_just_released("attack"):
		player_state = state.IDLE
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	update_animation()
