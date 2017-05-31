extends Node2D

const MAKS_Agxo = 100
var Agxo = 0
var korpo_nomo = ""

func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	for korpo in get_node("Kuglo").get_colliding_bodies():
		korpo_nomo = korpo.get_name()
		if korpo_nomo == "Malamiko" or korpo_nomo == "Skatolo_fiksita_malbona":
			korpo.free()
		queue_free()
		
	if Agxo < MAKS_Agxo:
		Agxo += 1
	else:
		Agxo = 0
		queue_free()
	
