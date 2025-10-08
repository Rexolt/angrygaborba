extends Node2D

func _ready() -> void:
	get_viewport().size_changed.connect(func() -> void: queue_redraw())
	set_process(true)

func _process(_dt: float) -> void:
	queue_redraw()

func _draw() -> void:
	var game := get_parent()
	if game == null or not game.has_node("StaticBody2D"):
		return
	var ground_y: float = (game.get_node("StaticBody2D") as Node2D).position.y
	var r := get_viewport_rect()
	# fű
	draw_rect(Rect2(Vector2(0, ground_y - 10.0), Vector2(r.size.x, 10.0)), Color8(63,169,63)) # #3fa93f
	# föld
	draw_rect(Rect2(Vector2(0, ground_y), Vector2(r.size.x, r.size.y - ground_y)), Color8(108,79,51)) # #6c4f33
