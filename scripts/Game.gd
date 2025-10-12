extends Node2D

# --- Alap node-hivatkozások ---
@onready var cannon: Node2D = $Cannon
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var level_root: Node2D = $"LevelRoot (Node2D)"
@onready var hud: Control = $Hud
@onready var level_select: Control = $LevelSelect

# --- Főmenü scene betöltése biztonságosan ---
var MainMenuScene: PackedScene = preload("res://ui/MainMenu.tscn")
@onready var main_menu: CanvasLayer = MainMenuScene.instantiate() as CanvasLayer

# --- Egyéb erőforrások ---
const LevelDBRes := preload("res://scripts/LevelDB.gd")
var BirdScene: PackedScene = preload("res://scenes/Bird.tscn")
var PigScene: PackedScene = preload("res://scenes/Pig.tscn")
var WoodScene: PackedScene = preload("res://scenes/Wood.tscn")
var ExplosionScene: PackedScene = preload("res://scenes/Explosion.tscn")

# --- Alap konstansok és állapotváltozók ---
const BASE_X: float = 500.0
var current_level: int = 0
var score: int = 0
var birds_left: int = 0
var game_over: bool = false


# =====================
#   INIT
# =====================
func _ready() -> void:
	# biztosítjuk, hogy legyen shape a talajon
	var col: CollisionShape2D = static_body.get_node("CollisionShape2D")
	if col.shape == null:
		var rs := RectangleShape2D.new()
		rs.size = Vector2(100000.0, 60.0)
		col.shape = rs

	# --- főmenü hozzáadása ---
	add_child(main_menu)
	if main_menu.has_signal("play_pressed"):
		main_menu.play_pressed.connect(_on_menu_play)
	if main_menu.has_signal("settings_pressed"):
		main_menu.settings_pressed.connect(_on_menu_settings)
	if main_menu.has_signal("credits_pressed"):
		main_menu.credits_pressed.connect(_on_menu_credits)
	main_menu.visible = true
	print("✅ MainMenu betöltve és aktív")

	# viewport-változás figyelése
	get_viewport().size_changed.connect(func() -> void:
		_place_ground()
		_place_cannon()
	)
	_place_ground()
	_place_cannon()
	_add_side_walls()

	# LevelSelect és HUD jelek
	if level_select.has_signal("level_chosen"):
		level_select.connect("level_chosen", Callable(self, "_on_level_chosen"))
	if hud.has_signal("restart_pressed"):
		hud.connect("restart_pressed", Callable(self, "_on_restart"))
	if hud.has_signal("pause_toggled"):
		hud.connect("pause_toggled", Callable(self, "_on_pause"))
	if hud.has_signal("back_to_levels"):
		hud.connect("back_to_levels", Callable(self, "_on_back_to_levels"))
	if hud.has_signal("next_level"):
		hud.connect("next_level", Callable(self, "_on_next_level"))

	cannon.set("game", self)
	# Nem indítunk pályát automatikusan, először menü jelenjen meg
	# show_level_select()


# =====================
#   ELHELYEZÉS ÉS PÁLYA
# =====================
func _place_ground() -> void:
	var h: float = get_viewport_rect().size.y
	static_body.position.y = floor(h * 0.85)

func _place_cannon() -> void:
	var ground_y: float = static_body.position.y
	cannon.global_position = Vector2(120.0, ground_y - 60.0)

func _add_side_walls() -> void:
	var ground_y: float = static_body.position.y

	var left_wall := StaticBody2D.new()
	var shape_left := RectangleShape2D.new()
	shape_left.size = Vector2(50, 2000)
	var col_left := CollisionShape2D.new()
	col_left.shape = shape_left
	left_wall.add_child(col_left)
	left_wall.position = Vector2(-200, ground_y - 800)
	add_child(left_wall)

	var right_wall := StaticBody2D.new()
	var shape_right := RectangleShape2D.new()
	shape_right.size = Vector2(50, 2000)
	var col_right := CollisionShape2D.new()
	col_right.shape = shape_right
	right_wall.add_child(col_right)
	right_wall.position = Vector2(2200, ground_y - 800)
	add_child(right_wall)

func show_level_select() -> void:
	level_select.visible = true
	hud.visible = false
	game_over = false
	score = 0
	birds_left = 0
	if hud.has_method("set_score"): hud.call("set_score", score)
	if hud.has_method("set_birds_left"): hud.call("set_birds_left", birds_left)
	if hud.has_method("set_level_info"): hud.call("set_level_info", 0, LevelDBRes.LEVELS.size())


# =====================
#   FŐMENÜ JELEK
# =====================
func _on_menu_play() -> void:
	print("▶ Játék indítása megnyomva")
	main_menu.visible = false
	show_level_select()

func _on_menu_settings() -> void:
	print("⚙ Beállítások menü (még üres)")

func _on_menu_credits() -> void:
	print("ℹ Készítők popup megnyitása (handled in MainMenu)")


# =====================
#   SZINTÉPÍTÉS
# =====================
func start_level(idx: int) -> void:
	current_level = idx
	level_select.visible = false
	hud.visible = true
	score = 0
	game_over = false

	for c in level_root.get_children():
		c.queue_free()

	var L: Dictionary = LevelDBRes.LEVELS[idx]
	birds_left = (L["birds"] as Array).size()
	if hud.has_method("set_score"): hud.call("set_score", score)
	if hud.has_method("set_birds_left"): hud.call("set_birds_left", birds_left)
	if hud.has_method("set_level_info"): hud.call("set_level_info", idx + 1, LevelDBRes.LEVELS.size())

	var ground_y: float = static_body.position.y

	# --- Disznók ---
	for p_any in (L["pigs"] as Array):
		var p: Dictionary = p_any
		var pig: RigidBody2D = PigScene.instantiate()
		pig.position = Vector2(BASE_X + float(p["x"]), ground_y + float(p["y"]))
		level_root.add_child(pig)

	# --- Fák / blokkok ---
	for b_any in (L["blocks"] as Array):
		var b: Dictionary = b_any
		var w: RigidBody2D = WoodScene.instantiate()
		level_root.add_child(w)
		w.rotation = float(b.get("a", 0.0))
		w.setup_size(Vector2(float(b["w"]), float(b["h"])))
		w.position = Vector2(BASE_X + float(b["x"]), ground_y + float(b["y"]))
		# Stabilizálás – ne robbanjanak szét spawnkor
		w.freeze = true
		await get_tree().process_frame
		w.freeze = false


# =====================
#   LÖVÉS ÉS MADARAK
# =====================
func _on_level_chosen(idx: int) -> void:
	start_level(idx)

func fire_next_bird(velocity: Vector2) -> void:
	if birds_left <= 0 or game_over:
		return
	birds_left -= 1
	if hud.has_method("set_birds_left"):
		hud.call("set_birds_left", birds_left)

	var b: RigidBody2D = BirdScene.instantiate()
	level_root.add_child(b)
	var spawn_pos: Variant = cannon.call("get_spawn_pos")
	if spawn_pos is Vector2:
		b.global_position = spawn_pos
	b.linear_velocity = velocity

func activate_flying_bird() -> void:
	for c in level_root.get_children():
		if c.has_method("is_bird") and c.call("is_bird"):
			var rb := c as RigidBody2D
			if rb.linear_velocity.length() > 1.0:
				c.call("activate")
				break


# =====================
#   HUD JELEK
# =====================
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
