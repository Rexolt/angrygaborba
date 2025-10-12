extends CanvasLayer

signal play_pressed
signal settings_pressed
signal credits_pressed

@onready var button_play: Button = $VBoxContainer/Button_Play
@onready var button_settings: Button = $VBoxContainer/Button_Settings
@onready var button_credits: Button = $VBoxContainer/Button_Credits
@onready var cannon_sprite: Sprite2D = $CannonSprite
@onready var credits_popup: Window = $CreditsPopup
@onready var close_button: Button = $CreditsPopup/CloseButton

func _ready() -> void:
	button_play.pressed.connect(func(): emit_signal("play_pressed"))
	button_settings.pressed.connect(func(): emit_signal("settings_pressed"))
	button_credits.pressed.connect(func(): _show_credits())

	# Saját X gomb kezelése
	close_button.pressed.connect(func(): credits_popup.hide())

	# ESC-re is lehessen zárni
	set_process_input(true)

func _show_credits() -> void:
	credits_popup.popup_centered()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if credits_popup.visible:
			credits_popup.hide()

func _process(delta: float) -> void:
	# Egérkövetés az ágyú sprite-ra
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var dir: Vector2 = (mouse_pos - cannon_sprite.position).normalized()
	cannon_sprite.rotation = dir.angle()
