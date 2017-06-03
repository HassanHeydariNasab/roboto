extends Node2D

const nivelo = 3
onready var triangulo = preload("res://Ajxoj/Triangulo.tscn")
var kadro = 0

func _ready():
	set_process(true)

func _process(delta):
	kadro += 1
	if kadro % 50 == 0 and kadro < 3500:
		var triangulo_ekzemplo = triangulo.instance()
		add_child(triangulo_ekzemplo)
		triangulo_ekzemplo.set_global_pos(Vector2(7180, 1800))
		triangulo_ekzemplo.get_node("Triangulo").set_linear_velocity(Vector2(0,100))