class_name AIParent
extends KinematicBody2D


var hp:int
onready var _velocity:Vector2 = Vector2.ZERO
onready var fsm := preload("res://States/FSM.gd").new()
onready var sprite := $AnimatedSprite
onready var character := get_node("../Protagonist")
onready var char_sprite_ref = get_node("../Protagonist/AnimatedSprite")
onready var speed:Vector2 = Vector2(100, 100) 
var previous_state
var self_direction = 1
#Сигнальная переменная для перехода в состояние атаки
var attack_mode:bool = false
var playerNear:bool = false
var out_of_reach:bool = false
#onready var wander_area = get_parent().get_node("WanderArea")
onready var playerSeen:bool = false
var is_dead:bool = false
#Маленькие экспериментики...
onready var can_enter_state:bool = false
onready var hurt_mode:bool = false
onready var can_be_attacked:bool = true
onready var ai_timer:Timer

signal dead


func set_speed(_speed:Vector2):
	speed = _speed

#Virtual function for attacking the player when he activate the shield
func on_attack_when_shield():
	pass


func setup_timer():
	ai_timer = Timer.new()
	add_child(ai_timer)
	ai_timer.autostart = true
	ai_timer.wait_time = 4
	ai_timer.set_one_shot(true)
	ai_timer.connect("timeout", self, "_timeout")

func _timeout():
	can_enter_state = true
	
	
func _ready():
	if char_sprite_ref != null:	
		fsm.enterState("idle")	
		


#Анимации ты уже знаешь
func get_new_animation()->String:
	var new_animation = ""
	if abs(_velocity.x) > 1 or playerSeen:
		new_animation = "run"
	if attack_mode:
#		_velocity = Vector2.ZERO
		new_animation = "attack"
	if hurt_mode:
		_velocity = Vector2.ZERO
		new_animation = "hurt"
		hurt_mode = false
	if is_dead and _velocity == Vector2.ZERO:
		new_animation = "death"
	if _velocity == Vector2.ZERO and not is_dead:
		new_animation = "idle"
	return new_animation

	
#Get self_direction to the player
func get_norm()->Vector2:
	if not character.is_dead:
		return (character.position - position).normalized()
	return Vector2.ZERO
	
	
#Функция для атаки игрока	
func rival_player(direction:Vector2)->void:
	if hp <= 0:
		fsm.enterState("death")
	else:
		var distance = position.distance_to(character.position)
		_velocity.x = direction.x * speed.x
		#Инвертирование спрайта
		if direction.x < 0:
			sprite.set_flip_h(true)
		else:
			sprite.set_flip_h(false)
		if distance <= 82 and ($Left_Cast.is_colliding() or $Right_Cast.is_colliding()):
			attack_mode = true
		if distance > 82:
			attack_mode = false

func idling():
	if hp <= 0:
		fsm.enterState("death")

func free_itself():
	print("i'm here")
	setup_timer()
	sprite.play("death")
	$CollisionShape2D.set_deferred("disabled", true)
	ai_timer.start()
	if can_enter_state:
		queue_free()
	
#Smoothly transition between the animations	
func gain_damage():
	hp -= 10
	print(hp)
	if hp > 0:
		fsm.enterState("aggressive")
	else:
		hp = 0
		fsm.enterState("death")


func wall_hit_resolvance()->void:
	if previous_state == fsm.STATES.AGGRESSIVE and out_of_reach:
		_velocity = Vector2.ZERO
		

func out_of_reach_behaviour()->void:
	_velocity = Vector2.ZERO
	

#Функция для перехода в разные состояния
func state_based_behaviour(delta:float):
	match fsm.getActiveState():
		fsm.STATES.AGGRESSIVE:
			rival_player(get_norm())
			previous_state = fsm.getActiveState()
		fsm.STATES.IDLE:
			idling()
			previous_state = fsm.getActiveState()
		fsm.STATES.DEATH:
			print("death state")
			out_of_reach = false
			is_dead = true
			hurt_mode = false
			free_itself()
			previous_state = fsm.getActiveState()
		fsm.STATES.HURT:
			out_of_reach = false
			hurt_mode = true
			gain_damage()
			previous_state = fsm.getActiveState()
		fsm.STATES.WALL_HIT:
			wall_hit_resolvance()
			previous_state = fsm.getActiveState()
		fsm.STATES.OUT_OF_REACH:
			out_of_reach_behaviour()
			previous_state = fsm.getActiveState()
			

		
func _physics_process(delta):
	#print(sprite.animation)
	_velocity = move_and_slide(_velocity)	
	on_attack_when_shield()
	#print(fsm.toString(fsm.getActiveState()))
	var flip_condition = true if self_direction == -1 or character.position.x < position.x else false
	
	sprite.set_flip_h(flip_condition) 
	state_based_behaviour(delta)
	sprite.play(get_new_animation())
	if hp <= 0:
		fsm.enterState("death")
		

#func _on_Timer_timeout():
#	fsm.enterState("walk_away")
