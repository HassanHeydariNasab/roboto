extends Panel

var agordejo = "user://agordejo.cfg"
onready var Agordejo = ConfigFile.new()
onready var Lingvo = get_node("Lingvo")
const lingvoj = ["eo", "en"]

func _ready():
	Agordejo.load(agordejo)
	var lingvo_indekso = Agordejo.get_value("Lingvo", "lingvo")
	if lingvo_indekso == null:
		lingvo_indekso = 0
	if TranslationServer.get_locale() != lingvoj[lingvo_indekso]:
		TranslationServer.set_locale(lingvoj[lingvo_indekso])
		get_tree().reload_current_scene()
	Lingvo.select(lingvo_indekso)
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene("res://Kontroloj/Cxefa_menuo.tscn")

func _on_Lingvo_item_selected( ID ):
	TranslationServer.set_locale(lingvoj[ID])
	Agordejo.set_value("Lingvo", "lingvo", ID)
	Agordejo.save(agordejo)
	get_tree().reload_current_scene()

func _on_Eliri_pressed():
	get_tree().change_scene("res://Kontroloj/Cxefa_menuo.tscn")
