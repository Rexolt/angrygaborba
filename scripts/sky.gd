extends Node2D

func _ready() -> void:
	get_viewport().size_changed.connect(func() -> void: queue_redraw())
	queue_redraw()

func _draw() -> void:
	var r: Rect2 = get_viewport_rect()
	draw_rect(r, Color8(139, 209, 255)) # #8bd1ff
