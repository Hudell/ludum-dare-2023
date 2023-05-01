extends Node

var map_spawn_name = ''
var map_name = ''
var current_stage = 1
var is_loading = false
var is_new_game = false
var caught_by_dog = false
var got_box = false:
	set(value):
		got_box = value
		if value:
			emit_signal("player_got_box")

var in_yard = false:
	set(value):
		in_yard = value
		emit_signal("in_yard_changed")

var in_dog_range = false:
	set(value):
		in_dog_range = value
		emit_signal("in_dog_range_changed")

var player_volume_level = 0.0:
	set(value):
		if value != player_volume_level:
			player_volume_level = value
			emit_signal("player_volume_changed", value)

signal map_changed
signal player_volume_changed
signal player_caught
signal in_dog_range_changed
signal in_yard_changed
signal player_got_box

func new_game():
	map_spawn_name = 'default'
	map_name = '1'
	caught_by_dog = false
	is_new_game = true
	is_loading = true
	got_box = false
	current_stage = 1

func change_map(new_map, spawn_name = 'default'):
	if get_tree().paused:
		return
	
	map_name = new_map
	map_spawn_name = spawn_name
	emit_signal("map_changed", new_map)

func got_caught():
	emit_signal("player_caught")

func restart():
	caught_by_dog = false
	got_box = false
	get_tree().paused = false
	change_map(str(current_stage))
