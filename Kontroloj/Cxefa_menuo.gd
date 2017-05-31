extends Panel

var agordejo = "user://agordejo.cfg"
onready var Agordejo = ConfigFile.new()
const lingvoj = ["eo", "en"]
var nivelo = 0

func _ready():
	Agordejo.load(agordejo)
	var lingvo_indekso = Agordejo.get_value("Lingvo", "lingvo")
	nivelo = Agordejo.get_value("Konservoj", "nivelo")
	var marko_por_konservi = false
	if lingvo_indekso == null:
		lingvo_indekso = 0
		Agordejo.set_value("Lingvo", "lingvo", 0)
		marko_por_konservi = true
	if nivelo == null:
		nivelo = 0
		Agordejo.set_value("Konservoj", "nivelo", 0)
		marko_por_konservi = true
	if marko_por_konservi:
		Agordejo.save(agordejo)
	if TranslationServer.get_locale() != lingvoj[lingvo_indekso]:
		TranslationServer.set_locale(lingvoj[lingvo_indekso])
		get_tree().reload_current_scene()

func _on_Eliri_pressed():
	get_tree().quit()

func _on_Ludi_pressed():
	get_tree().change_scene("res://Niveloj/Nivelo%s/Nivelo%s.tscn"%[nivelo, nivelo])

func _on_Agordoj_pressed():
	get_tree().change_scene("res://Kontroloj/Agordoj.tscn")
