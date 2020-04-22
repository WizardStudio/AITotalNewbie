class_name Protagonist
extends Actor

var	state
onready var sprite := $AnimatedSprite
onready var platform_detector := $PlatformDetector
var self_direction: int = 0
const MAX_JUMP_VELOCITY = -500

		
func get_direction()->int:
	if Input.is_action_pressed("move_left"):
		return -1
	else:
		return 1

func handle_motion():
	if Input.is_action_pressed("move_right"):
		sprite.set_flip_h(false)
		_velocity.x = speed.x
		sprite.play("running")
	elif Input.is_action_pressed("move_left"):
		sprite.set_flip_h(true)
		_velocity.x = -speed.x
		sprite.play("running")
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = -speed.y
		sprite.play("jump")
	else:
		_velocity = Vector2.ZERO
		sprite.play("idle")
	
func _physics_process(delta):
	self_direction = get_direction()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	var is_in_attack:bool = Input.is_action_pressed("sword_action")
	var is_in_air:bool = _velocity.y < 0
	if !is_on_floor():
		sprite.play("fall")
	handle_motion()

