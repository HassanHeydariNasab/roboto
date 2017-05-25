extends Node2D

var pafita = false
var atendado_p = 0
var smooth_zoom = 1
var target_zoom = 5
const ZOOM_SPEED = 1
var atendado_z = 0
var muso_lasita = false
var muso_lasado_konsumita = true
var muso_tenado = 0
var os = OS.get_name()

onready var K = get_node("K/RigidBody2D")
onready var T = get_node("TileMap")
onready var Kuglo = get_node("Kuglo/Kuglo")
onready var Kuglo_s = get_node("Kuglo/Kuglo/Sprite")
onready var C = get_node("K/RigidBody2D/Camera2D")


func _ready():
	set_process(true)
	set_process_input(true)

func _input(evento):
	if evento.type == InputEvent.MOUSE_BUTTON:
		if evento.is_pressed() == 1:
			muso_lasita = false
			muso_lasado_konsumita = false
			muso_tenado += 1
		elif evento.is_pressed() == 0:
			muso_lasita = true
			#Vi devas konsumi la laseco de la muso
		
func _process(delta):
	var akcelometro = Input.get_accelerometer()
	if (Input.is_action_pressed("iri") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.x > -3 and akcelometro.x < -1):
		K.set_angular_velocity(2)
	elif (Input.is_action_pressed("reveni") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.x < 3 and akcelometro.x > 1):
		K.set_angular_velocity(-2)
	elif Input.is_action_pressed("iri") or (os == "Android" and akcelometro.x < -3):
		K.set_angular_velocity(6)
	elif Input.is_action_pressed("reveni") or (os == "Android" and akcelometro.x > 3):
		K.set_angular_velocity(-6)
	if (Input.is_action_pressed("salti") or (os == "Android" and akcelometro.y > -1)) and T in K.get_colliding_bodies():
		K.set_linear_velocity(Vector2(K.get_linear_velocity().x, -200))
	if not pafita:
		#Kuglo.set_scale(Vector2(1, 1))
		#Kuglo_s.set_scale(Vector2(1, 1))
		var a = Kuglo.get_angle_to(get_global_mouse_pos())
		Kuglo_s.set_rot(a)
		Kuglo.set_global_pos(Vector2(K.get_global_pos().x+10, K.get_global_pos().y-110))
	if Input.is_action_pressed("pafi"):
		muso_tenado += 1
	if muso_lasita and not muso_lasado_konsumita and atendado_p == 0 and not pafita:
		muso_lasado_konsumita = true
		pafita = true
		Kuglo.set_scale(Vector2(muso_tenado, muso_tenado))
		Kuglo_s.set_scale(Vector2(muso_tenado/100+1, muso_tenado/100+1))
		print(muso_tenado)
		muso_tenado = 0
		var a = Kuglo.get_angle_to(get_global_mouse_pos())
		Kuglo_s.set_rot(a)
		Kuglo.set_linear_velocity(Vector2(cos(a)*3000, -sin(a)*3000))
	if pafita:
		atendado_p += 1
		if atendado_p > 50:
			pafita = false
			atendado_p = 0

	if atendado_z > 20 * delta:
		atendado_z = 0
		target_zoom = abs(K.get_linear_velocity().x/120)+1
	else:
		atendado_z += 1
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	if smooth_zoom != target_zoom:
		C.set_zoom(Vector2(smooth_zoom, smooth_zoom))
