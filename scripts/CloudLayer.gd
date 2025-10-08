extends Node2D

class Cloud:
	var pos: Vector2
	var r: float
	var s: float
	func _init(p: Vector2, radius: float, speed: float) -> void:
		pos = p; r = radius; s = speed

var clouds: Array[Cloud] = []

func _ready() -> void:
	randomize()
	var w := get_viewport_rect().size.x
	for i in 8:
		var x := randf() * (w + 400.0) - 200.0
		var y := 60.0 + randf() * 200.0
		var rr := 20.0 + randf() * 30.0
		var sp := 10.0 + randf() * 20.0
		clouds.append(Cloud.new(Vector2(x, y), rr, sp))
	get_viewport().size_changed.connect(func() -> void: queue_redraw())
	set_process(true)

func _process(dt: float) -> void:
	var w := get_viewport_rect().size.x
	for c in clouds:
		c.pos.x += (10.0 + c.s * 0.2) * dt
		if c.pos.x - 200.0 > w:
			c.pos.x = -200.0
	queue_redraw()

func _draw() -> void:
	var col := Color(1,1,1,0.85)
	for c in clouds:
		_draw_cloud(c.pos, c.r, col)

func _draw_cloud(p: Vector2, r: float, col: Color) -> void:
	draw_circle(p, r, col)
	draw_circle(p + Vector2(r * 0.8,  5), r * 0.9, col)
	draw_circle(p + Vector2(-r * 0.8, 10), r * 0.8, col)
