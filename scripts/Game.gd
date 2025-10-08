extends Node2D

@onready var cannon: Node2D = $Cannon
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var level_root: Node2D = $"LevelRoot (Node2D)"
@onready var hud: Control = $Hud
@onready var level_select: Control = $LevelSelect

const LevelDBRes := preload("res://scripts/LevelDB.gd")

var BirdScene: PackedScene = preload("res://scenes/Bird.tscn")
var PigScene: PackedScene = preload("res://scenes/Pig.tscn")
var WoodScene: PackedScene = preload("res://scenes/Wood.tscn")
var ExplosionScene: PackedScene = preload("res://scenes/Explosion.tscn")

const BASE_X: float = 500.0

var current_level: int = 0
var score: int = 0
var birds_left: int = 0
var game_over: bool = false

func _ready() -> void:
	# ha a CollisionShape2D-ben nem lenne shape, legyen
	var col: CollisionShape2D = static_body.get_node("CollisionShape2D")
	if col.shape == null:
		var rs := RectangleShape2D.new()
		rs.size = Vector2(100000.0, 40.0)
		col.shape = rs

	get_viewport().size_changed.connect(func() -> void:
		_place_ground()
		_place_cannon()
	)
	_place_ground()
	_place_cannon()

	# LevelSelect indítás
	if level_select.has_signal("level_chosen"):
		level_select.connect("level_chosen", Callable(self, "_on_level_chosen"))

	# HUD jelek (ha a te HUD.gd így küldi)
	if hud.has_signal("restart_pressed"): hud.connect("restart_pressed", Callable(self, "_on_restart"))
	if hud.has_signal("pause_toggled"): hud.connect("pause_toggled", Callable(self, "_on_pause"))
	if hud.has_signal("back_to_levels"): hud.connect("back_to_levels", Callable(self, "_on_back_to_levels"))
	if hud.has_signal("next_level"): hud.connect("next_level", Callable(self, "_on_next_level"))

	$Cannon.set("game", self)
	show_level_select()

func _place_ground() -> void:
	var h: float = get_viewport_rect().size.y
	static_body.position.y = floor(h * 0.85)

func _place_cannon() -> void:
	var ground_y: float = static_body.position.y
	cannon.global_position = Vector2(120.0, ground_y - 60.0)

func show_level_select() -> void:
	level_select.visible = true
	hud.visible = false
	game_over = false
	score = 0
	birds_left = 0
	if hud.has_method("set_score"): hud.call("set_score", score)
	if hud.has_method("set_birds_left"): hud.call("set_birds_left", birds_left)
	if hud.has_method("set_level_info"): hud.call("set_level_info", 0, LevelDBRes.LEVELS.size())

func start_level(idx: int) -> void:
	current_level = idx
	level_select.visible = false
	hud.visible = true
	score = 0
	game_over = false

	# előző scene elemek törlése
	for c in level_root.get_children():
		c.queue_free()

	var L: Dictionary = LevelDBRes.LEVELS[idx]
	birds_left = (L["birds"] as Array).size()
	if hud.has_method("set_score"): hud.call("set_score", score)
	if hud.has_method("set_birds_left"): hud.call("set_birds_left", birds_left)
	if hud.has_method("set_level_info"): hud.call("set_level_info", idx + 1, LevelDBRes.LEVELS.size())

	var ground_y: float = static_body.position.y

	# Disznók
	for p_any in (L["pigs"] as Array):
		var p: Dictionary = p_any
		var pig: RigidBody2D = PigScene.instantiate()
		pig.position = Vector2(BASE_X + float(p["x"]), ground_y - 22.0 + float(p.get("y", 0.0)))
		level_root.add_child(pig)

	# Fa blokkok
	for b_any in (L["blocks"] as Array):
		var b: Dictionary = b_any
		var w: RigidBody2D = WoodScene.instantiate()
		w.position = Vector2(BASE_X + float(b["x"]), ground_y + float(b["y"]))
		level_root.add_child(w)
		w.call_deferred("setup_size", Vector2(float(b["w"]), float(b["h"])))
		w.rotation = float(b.get("a", 0.0))

func _on_level_chosen(idx: int) -> void:
	start_level(idx)

func fire_next_bird(velocity: Vector2) -> void:
	if birds_left <= 0 or game_over:
		return
	birds_left -= 1
	if hud.has_method("set_birds_left"): hud.call("set_birds_left", birds_left)

	var b: RigidBody2D = BirdScene.instantiate()
	level_root.add_child(b)
	var spawn_pos: Variant = $Cannon.call("get_spawn_pos")
	if spawn_pos is Vector2:
		b.global_position = spawn_pos
	b.linear_velocity = velocity

func _on_restart() -> void:
	start_level(current_level)

func _on_pause() -> void:
	get_tree().paused = not get_tree().paused

func _on_back_to_levels() -> void:
	show_level_select()

func _on_next_level() -> void:
	var total := LevelDBRes.LEVELS.size()
	if current_level < total - 1:
		start_level(current_level + 1)
	else:
		show_level_select()

func activate_flying_bird() -> void:
	for c in level_root.get_children():
		if c.has_method("is_bird") and c.call("is_bird"):
			var rb := c as RigidBody2D
			if rb.linear_velocity.length() > 1.0:
				c.call("activate")
				break
