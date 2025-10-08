extends Node2D

@export var color: Color = Color(0.64, 0.74, 0.84)
@export var base_ratio: float = 0.7   # képernyőmagasság hányadán húzódjon az alap
@export var rough: int = 120          # vízszintes lépésköz (px)
@export var freq: float = 0.003
@export var amp: float = 0.7          # amplitúdó skála

func _ready() -> void:
	get_viewport().size_changed.connect(func() -> void: queue_redraw())
	queue_redraw()

func _draw() -> void:
	var r := get_viewport_rect()
	var base_y := r.size.y * base_ratio
	var points: PackedVector2Array = [Vector2(-100, base_y)]
	var x := 0.0
	while x <= r.size.x + 200.0:
		var y := base_y - sin(x * freq) * amp * 120.0 - cos(x * freq * 0.7) * amp * 80.0
		points.append(Vector2(x, y))
		x += float(rough)
	points.append(Vector2(r.size.x + 100.0, r.size.y + 50.0))
	points.append(Vector2(-100.0, r.size.y + 50.0))
	draw_colored_polygon(points, color)
