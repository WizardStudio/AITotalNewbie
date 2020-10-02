class_name Griffin
extends AIParent

var is_in_sight = false


func _ready():
	set_speed(Vector2(200,200))
	hp = 300
	

func on_attack_when_shielded():
	if sprite.animation == "attack" && sprite.frame == 8 :
		character.gain_damage()
	

func facing_direction()->float:
	var forward = get_transform().y
	var relative_vector = (character.position - position).normalized()
	return forward.dot(relative_vector)
	
		
func resolve_wall_collision()->void:
	if $Left_Cast.is_colliding() and not is_in_sight:
		var object = $Left_Cast.get_collider()
		if object.is_in_group("Walls"):
			_velocity = Vector2.ZERO

	if $Right_Cast.is_colliding():
		var object = $Right_Cast.get_collider()
		if object.is_in_group("Walls") and is_in_sight:
			_velocity = Vector2.ZERO
			if(playerNear):
				pass


func _physics_process(delta):
	if (attack_mode && position.distance_to(character.position) <= 78 && sprite.frame == 7):
		character.gain_damage()
	resolve_wall_collision()
	is_in_sight = facing_direction() > 0
	if (char_sprite_ref.animation == "attack_0" && char_sprite_ref.frame == 5 and position.distance_to(character.position) <= 82):
		fsm.enterState("hurt")
#	print(fsm.toString(fsm.getActiveState()))
	#print(sprite.animation)
#	if (get_angle() > 125.0):
#		out_of_reach = true
#		fsm.enterState("out_of_reach")
#	if (get_angle() < 125.0):
#		out_of_reach = false
#		fsm.enterState("aggressive")
	pass


func _on_RivalArea2_body_entered(body):
	if body == character:
		print("Griffin saw the player")
		playerNear = true
		fsm.enterState("aggressive")
		playerSeen = true
		print("DEBUG(RivalArea): Body entered")	


func _on_RivalArea2_body_exited(body):
	if body == character:
		if (playerSeen):
			print("DEBUG(RivalArea): Body exited")	
			_velocity = Vector2.ZERO
			playerSeen = false
			attack_mode = false
			playerNear = false
			fsm.enterState("idle")
				
		
			
