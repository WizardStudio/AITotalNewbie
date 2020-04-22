extends Node


static func start_jump(entity: KinematicBody2D,
					   velocity: Vector2,
					   jump_speed,
					   animation,
					   sprite_name)->void:
	velocity.y = jump_speed
	if animation != "" and sprite_name != "":
		entity.get_node(sprite_name).play(animation)

static func stop_jump(entity:KinematicBody2D,
			   velocity: Vector2,
			   jump_height_max: float,
			   animation: String = "",
			   sprite_name:String = "")->void:
		if velocity.y < jump_height_max:
			velocity.y = 0
			if animation != "" and sprite_name != "":
				entity.get_node(sprite_name).play(animation)
		
