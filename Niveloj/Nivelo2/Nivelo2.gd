extends Node2D

const nivelo = 2
onready var triangulo = preload("res://Ajxoj/Triangulo.tscn")
var kadro = 0

func _ready():
	set_process(true)

func _process(delta):
	kadro += 1
	if kadro % 10 == 0 and kadro < 3500:
		var triangulo_ekzemplo = triangulo.instance()
		add_child(triangulo_ekzemplo)
		triangulo_ekzemplo.set_global_pos(Vector2(1100+(kadro%500), -100))