extends KinematicBody2D

onready var playerSprite = $PlayerSprite
onready var attackCollision = $AttackArea/AttackCollision
onready var playerCollision = $PlayerCollision
var hit = preload("res://src/Level/Hit.tscn")

const velocity = 200
const resistence = Vector2(0, -1)
const damage = 10
var health = 100
var movement = Vector2()
var isAttacking = false
var isDodge = false
var isTakingDamage = false
var winFight = 0
signal lostFight


func animationPlayer(var animation):
	return playerSprite.play(animation)


func takeDamage():
	isTakingDamage = true
	
	$Timer.start()


func isDead(var health):
	if health <= 0:
		return true


func _ready():
	animationPlayer("Idle")


func _physics_process(delta):
	if !isDead(health):
		if Input.is_action_pressed("p1_right") \
		&& isAttacking == false \
		&& isTakingDamage == false:
			movement.x = velocity
			playerSprite.flip_h == false
			playerCollision.disabled = false
			animationPlayer("Walk")
		elif Input.is_action_pressed("p1_left") \
		&& isAttacking == false \
		&& isTakingDamage == false:
			movement.x = -velocity
			playerSprite.flip_h == true
			playerCollision.disabled = false
			animationPlayer("Walk")
		elif Input.is_action_pressed("p1_down") \
		&& isAttacking == false \
		&& isTakingDamage == false\
		&& movement.x == 0:
			playerCollision.disabled = true
			animationPlayer("Dodge")
		
		else:
			movement.x = 0
			if isAttacking == false && isTakingDamage == false:
				playerCollision.disabled = false
				animationPlayer("Idle")
		
		if Input.is_action_just_pressed("p1_attack") \
		&& isTakingDamage == false \
		&& winFight != 1:
			animationPlayer("Low Punch")
			attackCollision.disabled = false
			z_index = 1
			isAttacking = true
		
		if playerSprite.flip_h == true:
			attackCollision.disabled = true
			
		if winFight == 1:
			movement.x = 0
			animationPlayer("Idle")
		
	else:
		attackCollision.disabled = true
		animationPlayer("Dying")
		emit_signal("lostFight")
		
	movement = move_and_slide(movement, resistence)


func _on_PlayerSprite_animation_finished():
	if playerSprite.animation == "Low Punch" \
	or playerSprite.animation == "Taking Damage" \
	or playerSprite.animation == "Dodge":
		if !isDead(health):
			attackCollision.disabled = true
			playerCollision.disabled = false
			isAttacking = false
			isTakingDamage = false
			isDodge = false


func _on_AttackArea_body_entered(body):
	if body.name == "Player2":
		body.takeDamage()


func _on_Timer_timeout():
	health -= damage
	isTakingDamage = true
	if !isDead(health):
		animationPlayer("Taking Damage")
		var instance_hit = hit.instance()
		instance_hit.global_position = global_position
		instance_hit.position.x += 20
		instance_hit.position.y -= 50
		get_tree().get_current_scene().add_child(instance_hit)
		movement.x += 500
	
	get_node("../HUD/HealthP1").value -= damage

func _on_Player2_lostFight():
	winFight += 1




