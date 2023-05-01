@tool
extends TileMap

@export var load_camera_limits: bool = true
@export var configure_map_edges: bool = true

signal map_configured

func _ready():
	apply_map_area()
	call_deferred("set_player_at_spawn_pos")
	emit_signal("map_configured")

func apply_map_area():
	var mapArea = $MapArea
	
	if load_camera_limits:
		var camera = $Player/Camera2D
		camera.limit_top = mapArea.position.y
		camera.limit_left = mapArea.position.x
		camera.limit_right = mapArea.position.x + mapArea.size.x
		camera.limit_bottom = mapArea.position.y + mapArea.size.y
	
	if configure_map_edges:
		$MapEdges/LeftEdge.position.x = mapArea.position.x - 5
		$MapEdges/LeftEdge.position.y = (mapArea.position.y + mapArea.size.y) / 2
		$MapEdges/RightEdge.position.x = mapArea.position.x + mapArea.size.x + 5
		$MapEdges/RightEdge.position.y = (mapArea.position.y + mapArea.size.y) / 2
		
		$MapEdges/TopEdge.position.x = (mapArea.position.x + mapArea.size.x) / 2
		$MapEdges/TopEdge.position.y = mapArea.position.y - 5
		$MapEdges/BottomEdge.position.x = (mapArea.position.x + mapArea.size.x) / 2
		$MapEdges/BottomEdge.position.y = mapArea.position.y + mapArea.size.y + 5
		
		$MapEdges/LeftEdge/CollisionShape2D.shape.size.y = max(mapArea.position.x + mapArea.size.x, mapArea.position.y + mapArea.size.y)

func find_spawn_point(spawn_name):
	var default_spawn = null
	var spawnPoints = $SpawnPoints

	for spawn in spawnPoints.get_children():
		if spawn.name == spawn_name:
			return spawn
		elif spawn.name == "default":
			default_spawn = spawn

	return default_spawn

func set_player_at_spawn_pos():
	if Engine.is_editor_hint():
		return
	
	var point = find_spawn_point(Global.map_spawn_name)
	if point == null:
		return

	var player = $Player
	player.global_position = point.global_position
	if point.direction != Vector2.ZERO:
		player.set_direction(point.direction)


func _on_player_detector_player_seen():
	Global.in_yard = true

func _on_player_detector_player_lost():
	Global.in_yard = false

func _on_exit_player_seen():
	if Global.got_box:
		pass
