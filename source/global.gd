extends Node

var map_spawn_name = ''
var map_name = ''

var is_loading = false
var is_new_game = false

signal map_changed

func new_game():
	map_spawn_name = 'default'
	map_name = 'sample_stage'
	is_new_game = true
	is_loading = true

func change_map(new_map, spawn_name = 'default'):
	if get_tree().paused:
		return
	
	print("map change requested, from ", map_name, " to ", new_map, " at ", spawn_name)
	map_name = new_map
	map_spawn_name = spawn_name
	emit_signal("map_changed", new_map)
