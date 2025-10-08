extends Control

signal restart_pressed
signal pause_toggled
signal back_to_levels
signal next_level

@onready var score_lbl: Label = $Top/Score
@onready var birds_lbl: Label = $Top/Birds
@onready var level_lbl: Label = $Top/Level
@onready var banner: Panel = $Banner
@onready var banner_text: Label = $Banner/VBox/Text
@onready var next_btn: Button = $Banner/VBox/Buttons/Next

func _ready() -> void:
	$Top/Restart.pressed.connect(func() -> void: emit_signal("restart_pressed"))
	$Top/Back.pressed.connect(func() -> void: emit_signal("back_to_levels"))
	$Top/Pause.pressed.connect(func() -> void: emit_signal("pause_toggled"))
	$Banner/VBox/Buttons/Retry.pressed.connect(func() -> void: emit_signal("restart_pressed"))
	next_btn.pressed.connect(func() -> void: emit_signal("next_level"))

func set_score(v: int) -> void:
	score_lbl.text = "Pontszám: %d" % v

func set_birds_left(n: int) -> void:
	birds_lbl.text = "Madarak: %d" % n

func set_level_info(i: int, total: int) -> void:
	level_lbl.text = "Pálya: %d / %d" % [i, total]

func show_banner(win: bool, score: int) -> void:
	banner.visible = true
	banner_text.text = ("Siker! Pontszám: %d" % score) if win else ("Elfogytak a madarak!\nPontszám: %d" % score)
	next_btn.visible = win
