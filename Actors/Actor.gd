class_name Actor
extends KinematicBody2D

export (Vector2) var _velocity = Vector2.ZERO
var speed = Vector2(150,150)
var FLOOR_NORMAL = Vector2.UP
var GRAVITY = 300

func _physics_process(delta):
	_velocity.y += GRAVITY * delta
