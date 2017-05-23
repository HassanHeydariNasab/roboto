extends Node2D

func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	for korpo in get_node("RigidBody2D").get_colliding_bodies():
		print(korpo.get_name())
