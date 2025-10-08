extends Node

const PLANK_W := 16.0
const PLANK_H := 120.0
const SLAB_W  := 80.0
const SLAB_H  := 16.0

const LEVELS := [
	# 1: egy malac, két támasz + tető
	{
		"birds": ["sn"],
		"pigs": [ {"x":700.0, "y":-SLAB_H*0.5} ],
		"blocks": [
			{"x":660.0, "y":-PLANK_H*0.5, "w":PLANK_W, "h":PLANK_H, "a":0.0},
			{"x":740.0, "y":-PLANK_H*0.5, "w":PLANK_W, "h":PLANK_H, "a":0.0},
			{"x":700.0, "y":-PLANK_H - SLAB_H*0.5, "w":SLAB_W, "h":SLAB_H, "a":0.0}
		]
	},
	# 2: alacsony piramis, középen malac
	{
		"birds": ["sn","ssn"],
		"pigs": [ {"x":800.0, "y":-SLAB_H*0.5} ],
		"blocks": [
			{"x":760.0, "y":-SLAB_H*0.5, "w":SLAB_W, "h":SLAB_H},
			{"x":840.0, "y":-SLAB_H*0.5, "w":SLAB_W, "h":SLAB_H},
			{"x":800.0, "y":-SLAB_H*1.5 - PLANK_W*0.5, "w":PLANK_W, "h":PLANK_H, "a":0.0},
			{"x":800.0, "y":-SLAB_H*1.5 - PLANK_H - SLAB_H*0.5, "w":SLAB_W, "h":SLAB_H, "a":0.0}
		]
	},
	# 3: három oszlop, tető, két malac
	{
		"birds": ["sn","fsn"],
		"pigs": [ {"x":875.0, "y":-SLAB_H*0.5}, {"x":925.0, "y":-SLAB_H*0.5} ],
		"blocks": [
			{"x":850.0, "y":-PLANK_H*0.5, "w":PLANK_W, "h":PLANK_H},
			{"x":900.0, "y":-PLANK_H*0.5, "w":PLANK_W, "h":PLANK_H},
			{"x":950.0, "y":-PLANK_H*0.5, "w":PLANK_W, "h":PLANK_H},
			{"x":900.0, "y":-PLANK_H - SLAB_H*0.5, "w":SLAB_W*1.6, "h":SLAB_H}
		]
	}
]
