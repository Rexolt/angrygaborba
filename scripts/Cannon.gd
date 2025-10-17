extends Node2D

@export var base_power: float = 1800.0
@export var min_angle: float = -PI * 0.85
@export var max_angle: float = -PI * 0.05


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
	var pos := Vector2.ZERO

	# --- Érintés és egérpozíció egységesen ---
	if event is InputEventMouseMotion:
		pos = event.position
	elif event is InputEventMouseButton:
		pos = event.position
	elif event is InputEventScreenTouch:
		pos = event.position
	elif event is InputEventScreenDrag:
		pos = event.position
	else:
		return

	
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if not dragging:
			var to_angle: float = (pos - global_position).angle()
			rotation = clampf(to_angle, min_angle, max_angle)
		else:
			end_pos = pos
		get_viewport().set_input_as_handled()
		return

	
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) \
	or (event is InputEventScreenTouch and event.pressed):
		dragging = true
		start_pos = pos
		end_pos = start_pos
		get_viewport().set_input_as_handled()
		return

	
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed) \
	or (event is InputEventScreenTouch and not event.pressed):
		if dragging:
			dragging = false
			_fire_now()
		get_viewport().set_input_as_handled()
		return


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
	if sprite.texture == fire_texture and idle_texture != null:
		sprite.texture = idle_texture
