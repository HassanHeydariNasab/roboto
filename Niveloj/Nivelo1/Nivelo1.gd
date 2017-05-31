extends Node2D

var agordejo = "user://agordejo.cfg"
onready var Agordejo = ConfigFile.new()
const lingvoj = ["eo", "en"]

const nivelo = 1
var muso_lasita = false
var muso_lasado_konsumita = true
var muso_tenado = 0
var os = OS.get_name()

onready var K = get_node("K/RigidBody2D")
onready var T = get_node("TileMap")

func _iru_al_sceno(sceno):
	var s = load(sceno)
	var si = s.instance()
	get_parent().add_child(si)
	queue_free()

func _ready():
	Agordejo.load(agordejo)
	var lingvo_indekso = Agordejo.get_value("Lingvo", "lingvo")
	if TranslationServer.get_locale() != lingvoj[lingvo_indekso]:
		TranslationServer.set_locale(lingvoj[lingvo_indekso])
		get_tree().reload_current_scene()
	Agordejo.set_value("Konservoj", "nivelo", nivelo)
	Agordejo.save(agordejo)
	set_process(true)

func _process(delta):
	var K_koliziantaj = K.get_colliding_bodies()

	#iru al sekva nivelo
	for korpo in K_koliziantaj:
		if korpo.get_name() == "Transtempilo":
			get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo+1, nivelo+1])
		elif korpo.get_name() == "reTranstempilo":
			get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo-1, nivelo-1])