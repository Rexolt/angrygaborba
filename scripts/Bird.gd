extends RigidBody2D

signal activated(kind: String)
signal exploded(pos: Vector2)

@export_enum("normal", "speed", "bomb") var bird_type: String = "normal"

@onready var sprite: Sprite2D = $Sprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

var _is_activated: bool = false
var _spawn_time: float = 0.0

func _ready() -> void:
	_spawn_time = float(Time.get_ticks_msec()) / 1000.0

	# Precíz téglalap alakú hitbox a sprite alapján
	var tex_size: Vector2 = sprite.texture.get_size()
	var sprite_scale: Vector2 = sprite.scale

	# Kisebb hitbox a jobb fizikai érzéshez (80%-os arány)
	var hitbox_size: Vector2 = tex_size * sprite_scale * 0.15

	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = hitbox_size
	col.shape = rect
	col.position = Vector2.ZERO

	# Fizika – mozgás közbeni pontos ütközés
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	contact_monitor = true
	max_contacts_reported = 8

	linear_damp = 0.4
	angular_damp = 0.4

func is_bird() -> bool:
	return true

func activate() -> void:
	if _is_activated:
		return
	_is_activated = true

	match bird_type:
		"speed":
			# gyors madár – sebesség növelése
			linear_velocity *= 1.8
			emit_signal("activated", "speed")

		"bomb":
			# robbanó madár – robbanás létrehozása
			emit_signal("exploded", global_position)
			queue_free()

		_:
			pass
