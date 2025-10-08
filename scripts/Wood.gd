extends RigidBody2D

signal damaged(points: int)

@export var hp: float = 140.0
@export var sprite_full: Texture2D = preload("res://art/wood.png")
@export var sprite_50: Texture2D = preload("res://art/wood_50.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

var _spawn_time: float = 0.0

func _ready() -> void:
	_spawn_time = float(Time.get_ticks_msec()) / 1000.0

	# Anyagtulajdonságok – reaktívabb fa
	var pm: PhysicsMaterial = PhysicsMaterial.new()
	pm.friction = 0.6       # kicsit csúszósabb
	pm.bounce = 0.25        # több energia marad ütközéskor
	physics_material_override = pm

	# Kisebb csillapítás -> mozgékonyabb test
	linear_damp = 0.5
	angular_damp = 0.5

	# Több ütközés detektálása
	contact_monitor = true
	max_contacts_reported = 10

func setup_size(size: Vector2) -> void:
	var rs: Shape2D = col.shape
	if rs is RectangleShape2D:
		var rect := rs as RectangleShape2D
		rect.size = size

func apply_damage(d: float) -> void:
	var dmg: float = min(d, hp)
	hp -= d
	if hp <= 50.0 and sprite_50:
		sprite.texture = sprite_50
	emit_signal("damaged", int(round(dmg * 5.0)))
	if hp <= 0.0:
		queue_free()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var age: float = float(Time.get_ticks_msec()) / 1000.0 - _spawn_time
	if age < 0.4:
		return

	var v: float = linear_velocity.length()
	var w: float = absf(angular_velocity)

	# Érzékenyebb küszöbök
	var lin_threshold: float = 40.0
	var ang_threshold: float = 0.8

	if v > lin_threshold or w > ang_threshold:
		var lin_over: float = max(v - lin_threshold, 0.0)
		var ang_over: float = max(w - ang_threshold, 0.0) * 25.0
		var over: float = lin_over + ang_over
		if over > 0.0:
			apply_damage(over * 0.2)
