extends Node2D
class_name Island-Gen


var map_size := Vector2(200, 200) #100,100
onready var _tile_map :TileMap = $TileMap


func _ready() -> void:
	setup()
	draw_world(perlin_generate())


func setup() -> void:
	#Set the game window size relative to resolution
	var map_size_px := map_size * _tile_map.cell_size
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, map_size_px)
	OS.set_window_size(map_size_px/2) #/2


func perlin_generate():
	
	randomize()
	var noise := OpenSimplexNoise.new()
	noise.seed = randi()
	noise.period = 1 #5
	noise.octaves = 10 #15
	noise.persistence = 10 #10
	noise.lacunarity = 3 #4
	
	var worldmatrix = []
	
	for x in range(map_size.x):
		worldmatrix.append([])
		for y in range(map_size.y):
			worldmatrix[x].append([])
			var nx := x/map_size.x-0.5
			var ny := y/map_size.y-0.5
			var d = abs(nx) + abs(ny)
			worldmatrix[x][y] = (1 + ((noise.get_noise_2d(nx,ny)+1)/2) - d)*50
			
	return worldmatrix


func draw_world(wm) -> void:
	for x in range(len(wm)):
		for y in range(len(wm[x])):
			_tile_map.set_cell(x, y, height_to_tile(wm[x][y]))


func height_to_tile(height):
	if height > 60: #60
		return 0 
	elif height > 58: #55
		return 2 
	else:
		return 1
