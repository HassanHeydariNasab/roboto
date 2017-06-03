extends Node2D

var agordejo = "user://agordejo.cfg"
onready var Agordejo = ConfigFile.new()
const lingvoj = ["eo", "en"]

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
var vivo = 100

onready var K = get_node("RigidBody2D")
onready var C = get_node("RigidBody2D/Camera2D")
onready var F = get_node("Fiksito")
onready var Kuglo_sceno = preload("res://Kugloj/Kuglo.tscn")
onready var Sono_rotaciado = get_node("Sono_rotaciado")
onready var Sono_rotaciado_malrapida = get_node("Sono_rotaciado_malrapida")
onready var Sono_pafi = get_node("Sono_pafi")

func _ready():
	get_tree().set_auto_accept_quit(false)
	Agordejo.load(agordejo)
	var lingvo_indekso = Agordejo.get_value("Lingvo", "lingvo")
	if TranslationServer.get_locale() != lingvoj[lingvo_indekso]:
		TranslationServer.set_locale(lingvoj[lingvo_indekso])
		get_tree().reload_current_scene()
	Agordejo.set_value("Konservoj", "nivelo", get_tree().get_root().get_node("Bazo").nivelo)
	Agordejo.save(agordejo)
	set_process(true)
	set_process_input(true)

func _input(evento):
	if evento.type == InputEvent.MOUSE_BUTTON:
		if evento.button_mask == 1:
			muso_lasita = false
			muso_lasado_konsumita = false
			muso_tenado += 1
		elif evento.button_mask >= 3:
			muso_tenado = 0
		if evento.is_pressed() == 0:
			muso_lasita = true
			#Vi devas konsumi la laseco de la muso

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene("res://Kontroloj/Cxefa_menuo.tscn")

func _process(delta):
	var akcelometro = Input.get_accelerometer()
	var K_koliziantaj = K.get_colliding_bodies()
	if (Input.is_action_pressed("iri") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.x > -3 and akcelometro.x < -1):
		K.set_angular_velocity(2)
		#if not Sono_rotaciado_malrapida.is_playing():
			#Sono_rotaciado_malrapida.play()
	elif (Input.is_action_pressed("reveni") and Input.is_action_pressed("malrapidi")) or (os == "Android" and akcelometro.x < 3 and akcelometro.x > 1):
		K.set_angular_velocity(-2)
		#if not Sono_rotaciado_malrapida.is_playing():
			#Sono_rotaciado_malrapida.play()
	elif Input.is_action_pressed("iri") or (os == "Android" and akcelometro.x < -3):
		K.set_angular_velocity(7)
		#if not Sono_rotaciado.is_playing():
			#Sono_rotaciado.play()
	elif Input.is_action_pressed("reveni") or (os == "Android" and akcelometro.x > 3):
		K.set_angular_velocity(-7)
		#if not Sono_rotaciado.is_playing():
			#Sono_rotaciado.play()
	if (Input.is_action_pressed("salti") or (os == "Android" and akcelometro.y > -0.7)):
		if K_koliziantaj.size() > 0:
			if K_koliziantaj[0].get_name() == "TileMap":
				K.set_linear_velocity(Vector2(K.get_linear_velocity().x, -600))

	F.set_global_pos(K.get_global_pos())
	var a = F.get_angle_to(get_global_mouse_pos())
	if Input.is_action_pressed("pafi"):
		muso_tenado += 1
	if muso_lasita and not muso_lasado_konsumita and atendado_p == 0 and not pafita:
		muso_lasado_konsumita = true
		pafita = true
		vivo -= 1
		if vivo <= 0:
			var nivelo = get_tree().get_root().get_node("Bazo").nivelo
			get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo-1, nivelo-1])
		Sono_pafi.play()
		muso_tenado /= 4
		if muso_tenado > 10:
			muso_tenado = 10
		for i in range(muso_tenado):
			var Kuglo = Kuglo_sceno.instance()
			add_child(Kuglo)
			Kuglo.set_global_pos(F.get_global_pos())
			var a = F.get_angle_to(get_global_mouse_pos())
			Kuglo.set_rot(a)
			a -= deg2rad(90-i*8)
			Kuglo.get_node("Kuglo").set_linear_velocity(Vector2(cos(a)*3000+cos(a-deg2rad(8*i))*1000, -sin(a)*3000-sin(a-deg2rad(8*i))*1000))
		muso_tenado = 0
	if pafita:
		atendado_p += 1
		if atendado_p > 5:
			pafita = false
			atendado_p = 0

	#zomado de la fotilo
	if atendado_z > 20 * delta:
		atendado_z = 0
		target_zoom = abs(K.get_linear_velocity().x/300)+1
	else:
		atendado_z += 1
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	if smooth_zoom != target_zoom:
		C.set_zoom(Vector2(smooth_zoom, smooth_zoom))
		
	#se K kolizigis malbonajxon
	for korpo in K_koliziantaj:
		if korpo.get_name() == "Malbonakvo" or korpo.get_name() == "Triangulo":
			vivo -= 1
			if vivo <= 0:
				var nivelo = get_tree().get_root().get_node("Bazo").nivelo
				get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo-1, nivelo-1])
		elif korpo.get_name() == "Bonajxo":
			vivo+=korpo.n
			if vivo > 100:
				vivo = 100
			korpo.get_parent().free()
		
		#iru al sekva nivelo
		elif korpo.get_name() == "Transtempilo":
			var nivelo = get_tree().get_root().get_node("Bazo").nivelo
			get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo+1, nivelo+1])
		elif korpo.get_name() == "reTranstempilo":
			var nivelo = get_tree().get_root().get_node("Bazo").nivelo
			get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo-1, nivelo-1])
	
	#gxisdatigi la vido de la vivo
	#get_node("CanvasLayer/Vivo").set_val(vivo)
	get_node("RigidBody2D/Vivo").set_color("%xff6600"%((119-vivo)))

