class_name Blacksmith
extends Actor

onready var fsm := preload("res://States/FSM.gd").new()
onready var sprite := $AnimatedSprite
onready var character := get_node("../Protagonist")
var is_attacking := false
var ai_timer
var ai_think_time = 2
export (Vector2) var self_direction = Vector2(1, 0)
#Сигнальная переменная для перехода в состояние атаки
var attack_mode:bool = false
onready var wander_area = get_parent().get_node("WanderArea")
#Сигнальная переменная,определяющая,был ли игрок замечен ИИ
onready var playerSeen:bool = false
#Маленькие экспериментики...
onready var timer = $Timer
onready var TimerTime:bool = false

#С самого начала войти в "бродячее" состояние
func _ready():
	fsm.enterState("wander")
	setup_timer()
	
#Функция для активации бродячего состояния	
func wander_around(delta: float, self_direction: Vector2)->void:
	if	fsm.getActiveState() != fsm.STATES.IDLE:
		_velocity.x = (speed.x / 4) * self_direction.x
	
#Анимации ты уже знаешь
func get_new_animation()->String:
	var new_animation = ""
	if abs(_velocity.x) > 1 or playerSeen:
		new_animation = "walk"
	if attack_mode:
		_velocity = Vector2.ZERO
		new_animation = "attack"
	return new_animation

	
#Get self_direction to the player
func get_norm()->Vector2:
	return (character.position - position).normalized()
	
	
#Функция для атаки игрока	
func rival_player(direction:Vector2)->void:
	_velocity.x = direction.x * speed.x / 2
	#Инвертирование спрайта
	if direction.x < 0:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)
	if direction.x < 0:
		self_direction *= -1
	if position.distance_to(character.position) <= 40:
		attack_mode = true

func idling():
	_velocity = Vector2.ZERO
	sprite.play("idle")

#Функция для перехода в разные состояния
func state_based_behaviour(delta:float):
	match fsm.getActiveState():
		fsm.STATES.WANDER:
			wander_around(delta, self_direction)
		fsm.STATES.AGGRESSIVE:
			rival_player(get_norm())
		fsm.STATES.IDLE:
			idling()
		fsm.STATES.WALK_AWAY:
			walk_away(get_norm())
		

func walk_away(norm_to_player:Vector2)->void:
	_velocity.x = (speed.x / 4)
	sprite.set_flip_h(true)

				
func _physics_process(delta):
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)	
	var flip_condition = true if self_direction.x == -1 or character.position.x < position.x else false
	sprite.set_flip_h(flip_condition) 
	state_based_behaviour(delta)
	sprite.play(get_new_animation())

#Here comes code for handling entering/exiting areas
func _on_WanderArea_body_exited(body):
	if body == self:
		if fsm.getActiveState() == fsm.STATES.WANDER:
			self_direction *= -1
			print("DEBUG(WanderArea): Body exited")

func setup_timer():
	ai_timer = Timer.new()
	ai_timer.set_one_shot(true)
	ai_timer.set_wait_time(ai_think_time)
	ai_timer.connect("timeout", self, "on_timeout")
	add_child(ai_timer)
	

func on_timeout():
	fsm.enterState("walk_away")
			
#Если ИИ заметил игрока
func _on_RivalArea_body_entered(body):
	if body == character:
		print("Blacksmith saw the player")
		fsm.enterState("aggressive")
		playerSeen = true
		print("DEBUG(RivalArea): Body entered")	

#Если игрок вышел из опасной зоны		
func _on_RivalArea_body_exited(body):
	if body == character:
		print("DEBUG(RivalArea): Body exited")	
		playerSeen = false
		attack_mode = false
		_velocity = Vector2.ZERO
		sprite.play("taunt")
		ai_timer.start()
		
func _on_WanderArea_body_entered(body):
	if body == self:
		print("DEBUG(WanderArea): Body entered")
		fsm.enterState("wander")
		

#func _on_Timer_timeout():
#	fsm.enterState("walk_away")
