class_name Actor
extends KinematicBody2D


export (Vector2) var _velocity = Vector2.ZERO
var speed = Vector2(200,200)
var FLOOR_NORMAL = Vector2(0, -1)
var GRAVITY = 1200

func _physics_process(delta):
	pass
