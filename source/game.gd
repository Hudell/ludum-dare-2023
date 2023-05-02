extends Node2D

var next_map = null
var has_map = false

func _ready():
	Global.connect("map_changed", Callable(self, "change_map"))
	change_map(Global.map_name)
	
func _exit_tree():
	Global.disconnect("map_changed", Callable(self, "change_map"))

func load_map(map_name):
	return load("res://stages/" + map_name + ".tscn")

func change_map(new_map):
	if get_tree().paused:
		print("ERROR: map change requested while the tree is paused")
		return
	
	next_map = load_map(new_map)
	if next_map == null:
		return
	
	get_tree().paused = true
	call_deferred("replace_map")

func replace_map():
	var mapHolder = $MapHolder
	while mapHolder.get_child_count() > 0:
		mapHolder.remove_child(mapHolder.get_child(0))

	call_deferred("add_new_map")

func add_new_map():
	if !get_tree().paused:
		print("ERROR: tried to add a map while the tree is not paused")
		return
		
	var mapHolder = $MapHolder
	if mapHolder.get_child_count() > 0:
		print("ERROR: Tried to add more than one map")
		return

	var instance = next_map.instantiate()
	mapHolder.add_child(instance)
	has_map = true
	next_map = null
	
	get_tree().paused = false
	Global.is_loading = false
	Global.is_new_game = false
	Global.emit_signal("map_started")
