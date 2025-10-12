extends CanvasLayer

@onready var cannon_sprite: Sprite2D = $CannonSprite
@onready var play_button: Button = $Buttons/PlayButton
@onready var settings_button: Button = $Buttons/SettingsButton
@onready var credits_button: Button = $Buttons/CreditsButton

signal play_pressed
signal settings_pressed
signal credits_pressed

func _ready() -> void:
	play_button.pressed.connect(func(): emit_signal("play_pressed"))
	settings_button.pressed.connect(func(): emit_signal("settings_pressed"))
	credits_button.pressed.connect(func(): emit_signal("credits_pressed"))

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var target_pos: Vector2 = Vector2(mouse_pos.x, 250)
	cannon_sprite.position = cannon_sprite.position.lerp(target_pos, 6.0 * delta)
