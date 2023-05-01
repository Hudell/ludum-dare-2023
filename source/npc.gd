extends CharacterBody2D

@onready var routeTimer = $RouteTimer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

@export var route: NodePath: set = set_route
@export var acceleration = 200
@export var max_speed = 30
@export var friction = 500

var direction = Vector2.ZERO: set = set_direction
var route_node = null: set = set_route_node
var route_index = -1
var route_point = null
var initial_index = 0
var target_position = null: set = set_target_position

func load_route_node():
	if route != null:
		route_node = get_node_or_null(route)
	else:
		route_node = null
	
	route_index = -1
	if routeTimer && !routeTimer.is_stopped():
		routeTimer.stop()

func _ready():
	$Exclamation.visible = false
	load_route_node()
	
func set_route(value):
	if route == value:
		return

	route = value
	
	if is_inside_tree():
		load_route_node()

func set_route_node(value):
	route_node = value
	route_index = -1
	if routeTimer && !routeTimer.is_stopped():
		routeTimer.stop()

func set_target_position(value):
	target_position = value

func set_direction(new_direction):
	direction = new_direction
	animationTree.set("parameters/Idle/blend_position", new_direction)
	animationTree.set("parameters/Walk/blend_position", new_direction)

func _physics_process(_delta):
	if target_position != null:
		process_target_position()
	elif route_node != null:
		process_route()
	
	if velocity != Vector2.ZERO:
		animationState.travel("Walk")
		set_velocity(velocity)
		move_and_slide()
		velocity = velocity
	else:
		animationState.travel("Idle")

func process_route():
#	if !route_enabled:
#		return

	if !routeTimer.is_stopped():
		return

	# If we have a route point set, move towards it
	if route_point != null:
		if move_towards_point(route_point):
			return
		route_point = null
	
	# If we don't have a route or we're already on it, then try to find a new point
	if progress_route():
		if !move_towards_point(route_point):
			route_point = null
		return

func process_target_position():
	if move_towards_point(target_position, false):
		return
	target_position = null

func move_towards_point(point, is_route = true):
	var distance = global_position - point.global_position
	var x = abs(distance.x)
	var y = abs(distance.y)
	if x <= 1 && y <= 1:
		velocity = Vector2.ZERO
		on_reach_point(point, is_route)
		return false
	
	self.direction = global_position.direction_to(point.global_position)
	
	velocity = direction * max_speed
	return true

func progress_route(first_call = true):
	if !routeTimer.is_stopped():
		return
	
#	if !visibilityNotifier.is_on_screen():
#		return
	
	if route_node == null || route_node.get_child_count() == 0:
		route_point = null
		route_index = -1
		return false

	var point_count = route_node.get_child_count()

	if route_index < 0 || route_index == point_count - 1:
		route_index = 0
	else:
		route_index += 1
		
	route_point = route_node.get_child(route_index)
	if 'is_route_point' in route_point:
		return true

	if first_call:
		initial_index = route_index
	elif initial_index == route_index:
		route_point = null
		route_index = -1
		return false
	
	return progress_route(false)

func start_route_timer(min_seconds, max_seconds, skip_chance):
	if !routeTimer.is_stopped():
		return
		
	if randi() % 100 < skip_chance:
		return
	
	var actual_min_seconds = max(0, min_seconds)
	var actual_max_seconds = max(max_seconds, min_seconds)
	var diff_seconds = actual_max_seconds - actual_min_seconds

	var additional_seconds = randi() % diff_seconds if diff_seconds > 0 else 0
	var time = actual_min_seconds + additional_seconds
	
	if time > 0:
		routeTimer.start(time)

func stop_route_timer():
	if routeTimer.is_stopped():
		return
	
	routeTimer.start()

func on_reach_point(point, _is_route = true):
	match point.direction_to_face:
		"Left":
			set_direction(Vector2.LEFT)
		"Right":
			set_direction(Vector2.RIGHT)
		"Down":
			set_direction(Vector2.DOWN)
		"Up":
			set_direction(Vector2.UP)
		"Free":
			queue_free()

	start_route_timer(point.min_seconds_to_stay, point.max_seconds_to_stay, point.skip_chance)
#	if is_route:
#		emit_signal('route_point_reached', point)
#	else:
#		emit_signal('target_position_reached')

func _on_player_detector_player_seen():
	$Exclamation.play("default")
	$Exclamation.visible = true
	Global.got_caught()

func _on_exclamation_animation_finished():
	$Exclamation.visible = false
