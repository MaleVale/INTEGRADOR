extends Node2D

@onready var time_label: Label     = find_child("TimeLabel", true, false)
@onready var key_label: Label      = find_child("KeyLabel",  true, false)
@onready var gold_label: Label     = find_child("GoldLabel", true, false)
@onready var mensaje: Label        = find_child("Mensaje",   true, false)

@onready var music_ida: AudioStreamPlayer    = $AudioIda
@onready var music_vuelta: AudioStreamPlayer = $AudioVuelta


func play_ida():
	if music_vuelta:
		music_vuelta.stop()
	if music_ida:
		music_ida.play()


func play_vuelta():
	if music_ida:
		music_ida.stop()
	if music_vuelta:
		music_vuelta.play()


func set_time(seconds: int) -> void:
	if time_label:
		time_label.text = "Tiempo: " + str(seconds)


func set_key(has_key: bool) -> void:
	if key_label:
		key_label.text = "Llave: " + ("Sí" if has_key else "No")


func set_gold(amount: int) -> void:
	if gold_label:
		gold_label.text = "Oro: " + str(amount) + "/20"


func set_message(text: String) -> void:
	if mensaje:
		mensaje.text = text
