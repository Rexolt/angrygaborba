extends RigidBody2D

signal damaged(points: int)
signal died(points: int)

@export var hp: float = 60.0
var alive: bool = true
var _spawn_time: float = 0.0

func is_pig() -> bool:
	return true

func _ready() -> void:
	_spawn_time = float(Time.get_ticks_msec()) / 1000.0

	var pm: PhysicsMaterial = PhysicsMaterial.new()
	pm.friction = 0.8
	pm.bounce = 0.0
	physics_material_override = pm

	linear_damp = 1.5
	angular_damp = 1.5

func apply_damage(d: float) -> void:
	if not alive:
		return
	var dmg: float = min(d, hp)
	hp -= d
	emit_signal("damaged", int(round(dmg * 5.0)))
	if hp <= 0.0:
		alive = false
		emit_signal("died", 5000)
		queue_free()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var age: float = (float(Time.get_ticks_msec()) / 1000.0) - _spawn_time
	if age < 0.7:
		return

	var v: float = linear_velocity.length()
	var w: float = absf(angular_velocity)

	var lin_threshold: float = 55.0
	var ang_threshold: float = 1.0

	if v > lin_threshold or w > ang_threshold:
		var lin_over: float = max(v - lin_threshold, 0.0)
		var ang_over: float = max(w - ang_threshold, 0.0) * 25.0
		var over: float = lin_over + ang_over
		if over > 0.0:
			apply_damage(over * 0.18)
