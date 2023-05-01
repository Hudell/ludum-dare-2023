extends Node

var map_spawn_name = ''
var map_name = ''

var is_loading = false
var is_new_game = false
var player_volume_level = 0.0:
	set(value):
		if value != player_volume_level:
			player_volume_level = value
			emit_signal("player_volume_changed", value)

signal map_changed
signal player_volume_changed
signal player_caught

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

func got_caught():
	emit_signal("player_caught")
