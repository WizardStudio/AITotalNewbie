extends AIParent

func _ready():
	hp = 250



func on_attack_when_shield():
	if (character.shield_activated):
		can_be_attacked = false
	if not character.shield_activated:
		can_be_attacked = true

func _physics_process(delta):
#	if (attack_mode && position.distance_to(character.position) <= 78 && sprite.frame == 11 && can_be_attacked):
	#	character.gain_damage()
	
	if (char_sprite_ref.animation == "attack_0" && char_sprite_ref.frame == 4 and position.distance_to(character.position) <= 50):
		fsm.enterState("hurt")
	
func _on_RivalArea1_body_entered(body):
	if body == character:
		print("Griffin saw the player")
		playerNear = true
		fsm.enterState("aggressive")
		playerSeen = true
		print("DEBUG(RivalArea): Body entered")	


func _on_RivalArea1_body_exited(body):
	if body == character:
		if (playerSeen):
			print("DEBUG(RivalArea): Body exited")	
			_velocity = Vector2.ZERO
			playerSeen = false
			attack_mode = false
			playerNear = false
			fsm.enterState("idle")
			
