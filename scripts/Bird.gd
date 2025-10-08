extends RigidBody2D

signal activated(kind: String)
signal exploded(pos: Vector2)

@export var kind: String = "sn" # sn, ssn, fsn
var used_power: bool = false
var alive: bool = true

@onready var sprite: Sprite2D = $Sprite2D

const TEX := {
	"sn": preload("res://art/sn.png"),
	"ssn": preload("res://art/ssn.png"),
	"fsn": preload("res://art/fsn.png"),
}

func is_bird() -> bool:
	return true

func _ready() -> void:
	scale = Vector2(0.6, 0.6)
	$CollisionShape2D.shape.radius = 14.0
	sprite.texture = TEX.get(kind, TEX["sn"])
	
	contact_monitor = true
	max_contacts_reported = 4
	$SelfDestruct.timeout.connect(func() -> void: queue_free())
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		body_entered.connect(_on_body_entered)




func activate() -> void:
	if used_power or not alive:
		return
	used_power = true
	if kind == "ssn":
		linear_velocity *= 1.8
		emit_signal("activated", kind)
	elif kind == "fsn":
		alive = false
		emit_signal("exploded", global_position)
		queue_free()

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	var v: Vector2 = linear_velocity
	if v.length() > 1.0:
		rotation = v.angle()




func _on_body_entered(_body: Node) -> void:
	if kind == "fsn" and not used_power:
		activate()
