extends Node2D

const nivelo = 1
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
onready var C = get_node("K/RigidBody2D/Camera2D")
onready var F = get_node("Fiksito")
onready var Kuglo_sceno = preload("res://Kugloj/Kuglo.tscn")

func _iru_al_sceno(sceno):
	var s = load(sceno)
	var si = s.instance()
	get_parent().add_child(si)
	queue_free()

func _ready():
	set_process(true)
	set_process_input(true)

func _input(evento):
	if evento.type == InputEvent.MOUSE_BUTTON:
		if evento.button_mask == 1:
			muso_lasita = false
			muso_lasado_konsumita = false
			muso_tenado += 1
		if evento.is_pressed() == 0:
			muso_lasita = true
			#Vi devas konsumi la laseco de la muso
		
func _process(delta):
	var akcelometro = Input.get_accelerometer()
	var K_koliziantaj = K.get_colliding_bodies()
	if (Input.is_action_pressed("iri") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.x > -3 and akcelometro.x < -1):
		K.set_angular_velocity(2)
	elif (Input.is_action_pressed("reveni") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.x < 3 and akcelometro.x > 1):
		K.set_angular_velocity(-2)
	elif Input.is_action_pressed("iri") or (os == "Android" and akcelometro.x < -3):
		K.set_angular_velocity(6)
	elif Input.is_action_pressed("reveni") or (os == "Android" and akcelometro.x > 3):
		K.set_angular_velocity(-6)
	if ((Input.is_action_pressed("salti") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.y > -1)) and (K_koliziantaj.size() != 0):
		K.set_linear_velocity(Vector2(K.get_linear_velocity().x, -200))
	elif (Input.is_action_pressed("salti") or (os == "Android" and akcelometro.y > -1)) and (K_koliziantaj.size() != 0):
		K.set_linear_velocity(Vector2(K.get_linear_velocity().x, -300))
	F.set_global_pos(K.get_global_pos())
	var a = F.get_angle_to(get_global_mouse_pos())
	if Input.is_action_pressed("pafi"):
		muso_tenado += 1
	if muso_lasita and not muso_lasado_konsumita and atendado_p == 0 and not pafita:
		muso_lasado_konsumita = true
		pafita = true
		muso_tenado /= 4
		if muso_tenado > 10:
			muso_tenado = 10
		for i in range(muso_tenado):
			var Kuglo = Kuglo_sceno.instance()
			add_child(Kuglo)
			Kuglo.set_global_pos(F.get_global_pos())
			var a = F.get_angle_to(get_global_mouse_pos())
			Kuglo.set_rot(a)
			a -= deg2rad(90-i*5)
			Kuglo.get_node("Kuglo").set_linear_velocity(Vector2(cos(a)*3000+cos(a-deg2rad(5*i))*1000, -sin(a)*3000-sin(a-deg2rad(5*i))*1000))
		muso_tenado = 0
	if pafita:
		atendado_p += 1
		if atendado_p > 5:
			pafita = false
			atendado_p = 0
	
	#zomado de la fotilo
	if atendado_z > 20 * delta:
		atendado_z = 0
		target_zoom = abs(K.get_linear_velocity().x/120)+2
	else:
		atendado_z += 1
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	if smooth_zoom != target_zoom:
		C.set_zoom(Vector2(smooth_zoom, smooth_zoom))
	
	#iru al sekva nivelo
	for korpo in K_koliziantaj:
		if korpo.get_name() == "Transtempilo":
			_iru_al_sceno("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo+1, nivelo+1])
		elif korpo.get_name() == "reTranstempilo":
			_iru_al_sceno("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo-1, nivelo-1])

func _on_ButtonEO_pressed():
	TranslationServer.set_locale("eo")
	_iru_al_sceno("res://Niveloj/Nivelo1/Nivelo1.tscn")

func _on_ButtonEN_pressed():
	TranslationServer.set_locale("en")
	_iru_al_sceno("res://Niveloj/Nivelo1/Nivelo1.tscn")