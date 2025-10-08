extends Control

signal level_chosen(idx: int)

@onready var list: HBoxContainer = $List

const LevelDBRes := preload("res://scripts/LevelDB.gd")

func _ready() -> void:
	_build()

func _build() -> void:
	_clear_list()
	var total: int = LevelDBRes.LEVELS.size()
	for i in total:
		var b := Button.new()
		b.text = str(i + 1)
		var idx: int = i
		b.pressed.connect(func() -> void:
			emit_signal("level_chosen", idx)
		)
		list.add_child(b)

func _clear_list() -> void:
	for c in list.get_children():
		c.queue_free()
