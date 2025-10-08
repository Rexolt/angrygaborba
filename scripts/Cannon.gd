extends Node2D

@export var base_power: float = 1800.0
@export var min_angle: float = -PI * 0.85
@export var max_angle: float = -PI * 0.05

# 🔥 Ágyú villanás (lövés animáció) beállítások
@export var fire_flash_time: float = 0.18
@export var idle_texture: Texture2D
@export var fire_texture: Texture2D

var dragging: bool = false
var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
var game: Node = null

@onready var muzzle: Marker2D = $Muzzle
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Ha nincs explicit idle texture beállítva, használjuk a Sprite jelenlegi textúráját.
	if idle_texture == null and sprite != null:
		idle_texture = sprite.texture

func get_spawn_pos() -> Vector2:
	return muzzle.global_position

func current_launch_velocity() -> Vector2:
	if dragging:
		var d: Vector2 = start_pos - end_pos
		var power_scale: float = clampf(d.length() / 180.0, 0.0, 1.0)
		var ang: float = d.angle() + PI
		return Vector2(cos(ang), sin(ang)) * base_power * power_scale
	else:
		return Vector2(cos(rotation), sin(rotation)) * base_power * 0.7

func _unhandled_input(event: InputEvent) -> void:
	# 1) Egér mozgás – célzás
	if event is InputEventMouseMotion:
		if not dragging:
			var to_angle: float = (get_global_mouse_position() - global_position).angle()
			rotation = clampf(to_angle, min_angle, max_angle)
		else:
			end_pos = get_global_mouse_position()
		get_viewport().set_input_as_handled()
		return

	# 2) Egér gomb – húzás és elengedés
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				dragging = true
				start_pos = get_global_mouse_position()
				end_pos = start_pos
			else:
				if dragging:
					dragging = false
					_fire_now()
			get_viewport().set_input_as_handled()
		return

	# 3) InputMap akciók
	if event is InputEventAction:
		var ia := event as InputEventAction
		match ia.action:
			"aim_start":
				if ia.pressed:
					dragging = true
					start_pos = get_global_mouse_position()
					end_pos = start_pos
					get_viewport().set_input_as_handled()
			"aim_end":
				if not ia.pressed and dragging:
					dragging = false
					_fire_now()
					get_viewport().set_input_as_handled()
			"activate":
				if ia.pressed and game != null and game.has_method("activate_flying_bird"):
					game.call("activate_flying_bird")
					get_viewport().set_input_as_handled()

# --- belső segéd: tényleges lövés + villanás ---
func _fire_now() -> void:
	if game != null:
		game.call("fire_next_bird", current_launch_velocity())
	_flash_fire()

func _flash_fire() -> void:
	if sprite == null:
		return
	if fire_texture != null:
		sprite.texture = fire_texture
		await get_tree().create_timer(fire_flash_time).timeout
	# csak akkor állítsuk vissza, ha még mindig a fire texture van rajta
	if sprite.texture == fire_texture and idle_texture != null:
		sprite.texture = idle_texture
