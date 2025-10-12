extends Node

# Használt elemméretek (pixelekben)
const PLANK_W := 16.0
const PLANK_H := 120.0
const SLAB_W  := 80.0
const SLAB_H  := 16.0

# Alap x eltolás (balról)
const BASE_X := 650.0

# Pályák listája
const LEVELS := [
	# ========== LEVEL 1 ==========
	{
		"birds": ["normal", "speed"],

		"pigs": [
			{"x": BASE_X + 70.0, "y": -SLAB_H * 0.5}
		],

		"blocks": [
			# Alaplap (talajon fekvő)
			{"x": BASE_X, "y": -SLAB_H * 0.5, "w": SLAB_W * 2, "h": SLAB_H, "a": 0.0},

			# Jobb oldali oszlop
			{"x": BASE_X + 70.0, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},

			# Bal oldali oszlop
			{"x": BASE_X - 70.0, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},

			# Tetőlap
			{"x": BASE_X, "y": -PLANK_H - SLAB_H * 0.5, "w": SLAB_W * 2, "h": SLAB_H, "a": 0.0}
		]
	},

	# ========== LEVEL 2 ==========
	{
		"birds": ["normal", "speed", "bomb"],

		"pigs": [
			{"x": BASE_X + 60.0, "y": -SLAB_H * 0.5},
			{"x": BASE_X - 60.0, "y": -PLANK_H - SLAB_H * 1.5}
		],

		"blocks": [
			# Alaplapok
			{"x": BASE_X, "y": -SLAB_H * 0.5, "w": SLAB_W * 3, "h": SLAB_H, "a": 0.0},

			# Oszlopok
			{"x": BASE_X - 80.0, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},
			{"x": BASE_X + 80.0, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},

			# Tetőlap (felső szint)
			{"x": BASE_X, "y": -PLANK_H - SLAB_H * 0.5, "w": SLAB_W * 3, "h": SLAB_H, "a": 0.0},

			# Felső szint oszlopai
			{"x": BASE_X - 40.0, "y": -PLANK_H - SLAB_H - PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},
			{"x": BASE_X + 40.0, "y": -PLANK_H - SLAB_H - PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},

			# Felső tető
			{"x": BASE_X, "y": -PLANK_H * 2 - SLAB_H * 1.5, "w": SLAB_W * 2, "h": SLAB_H, "a": 0.0}
		]
	},

	# ========== LEVEL 3 ==========
	{
		"birds": ["speed", "speed", "bomb"],

		"pigs": [
			{"x": BASE_X + 50.0, "y": -SLAB_H * 0.5},
			{"x": BASE_X - 50.0, "y": -SLAB_H * 0.5},
			{"x": BASE_X, "y": -PLANK_H - SLAB_H * 1.5}
		],

		"blocks": [
			# Alsó alaplap
			{"x": BASE_X, "y": -SLAB_H * 0.5, "w": SLAB_W * 3, "h": SLAB_H, "a": 0.0},

			# Alsó oszlopok
			{"x": BASE_X - 80.0, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},
			{"x": BASE_X, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},
			{"x": BASE_X + 80.0, "y": -PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},

			# Középső tető
			{"x": BASE_X, "y": -PLANK_H - SLAB_H * 0.5, "w": SLAB_W * 3, "h": SLAB_H, "a": 0.0},

			# Felső oszlopok
			{"x": BASE_X - 50.0, "y": -PLANK_H - SLAB_H - PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},
			{"x": BASE_X + 50.0, "y": -PLANK_H - SLAB_H - PLANK_H * 0.5, "w": PLANK_W, "h": PLANK_H, "a": 0.0},

			# Felső tető
			{"x": BASE_X, "y": -PLANK_H * 2 - SLAB_H * 1.5, "w": SLAB_W * 2, "h": SLAB_H, "a": 0.0}
		]
	}
]
