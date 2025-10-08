extends Area2D

signal damage_score(points: int)

@export var radius: float = 140.0
@export var force: float = 15000.0

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	explode()
	await get_tree().create_timer(0.05).timeout
	queue_free()

func explode() -> void:
	var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = $"CollisionShape2D".shape
	params.transform = global_transform
	params.collide_with_areas = false
	params.collide_with_bodies = true

	var results: Array = space.intersect_shape(params, 64)
	for r_any in results:
		var r: Dictionary = r_any
		var b: Variant = r.get("collider")
		if b is RigidBody2D:
			var body := b as RigidBody2D
			var dir: Vector2 = (body.global_position - global_position)
			var d: float = max(dir.length(), 1.0)
			var f: float = (1.0 - d / radius)
			if f <= 0.0:
				continue
			var impulse: Vector2 = dir.normalized() * (force * f)
			body.apply_impulse(impulse)
			if body.has_method("apply_damage"):
				var damage_val: float = force * f * 0.01
				body.call("apply_damage", damage_val)
				emit_signal("damage_score", int(round(damage_val * 5.0)))
