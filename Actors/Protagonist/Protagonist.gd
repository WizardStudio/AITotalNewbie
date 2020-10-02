class_name Protagonist
extends Actor

var entry_position
var run_speed = 200
var shield_activated:bool = false
var jump_speed = -650
var roll_speed = 350
var jumping = false
var attacking = false
var attackNum = false
var direction = 1
var hp:int = 100

var is_dead = false	

func gain_damage():
	if hp > 0:
		hp -= 10
	if hp <= 0:
		pass_away()

func pass_away():
	$AnimatedSprite.play("death")
	$CollisionShape2D.set_deferred("disabled", true)
	is_dead = true

func _ready():
	entry_position = position

func get_input():
	if _velocity.y > 1000:
		_velocity.y = -1200
	_velocity.x = 0
	var jump = Input.is_action_pressed("jump")
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var attack = Input.is_action_pressed("sword_action")
	var shield_on = Input.is_action_pressed("shield")
	var shield_off = Input.is_action_just_released("shield")
	
	if right:
		_velocity.x = run_speed * direction
		$AnimatedSprite.flip_h = false
	if left:
		_velocity.x = -run_speed * direction
		$AnimatedSprite.flip_h = true	
	if jump and is_on_floor():
		jumping = true
		_velocity.y = jump_speed
	
	if attack and _velocity.x == 0:
		attacking = true
	if shield_on:
		shield_activated = true
	if shield_off:
		shield_activated = false
		
	if attacking and $AnimatedSprite.frame == 5:
		attacking = false
		if attackNum:
			attackNum = false	
		else:
			attackNum = true
	if jumping and not is_on_floor():
		if _velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	elif attacking:
		if not attackNum:
			$AnimatedSprite.play("attack_0")
		else:
			$AnimatedSprite.play("attack_0")
			
	elif (right or left) and is_on_floor():
		$AnimatedSprite.play("running")
	else:
		$AnimatedSprite.play("idle")		
					

func _physics_process(delta):
	
	if is_dead:
		return
	get_input()
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
