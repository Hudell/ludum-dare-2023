@tool
extends CharacterBody2D

@export_category("Initial Data")
@export_enum("Down", "Left", "Right", "Up") var initial_direction: String = "Down":
	get:
		return initial_direction
	set(value):
		initial_direction = value
		if is_inside_tree():
			match value:
				"Down":
					set_direction(Vector2.DOWN)
				"Left":
					set_direction(Vector2.LEFT)
				"Right":
					set_direction(Vector2.RIGHT)
				"Up":
					set_direction(Vector2.UP)

const ACCELERATION = 100.0
const BASE_SPEED = 70

var max_speed = BASE_SPEED

enum {
	MOVE,
}

var state = MOVE: set = set_state
var last_direction = Vector2.DOWN

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
#@onready var hurtbox = $Hurtbox
#@onready var objectDetection = $Pivot/ObjectDetection

func _ready():
	animationTree.active = true
	update_direction()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	match state:
		MOVE:
			move_state(delta)

func set_state(value):
	state = value

func set_direction(value):
	last_direction = value
	update_direction()

func update_direction():
	animationTree.set("parameters/Idle/blend_position", last_direction)
	animationTree.set("parameters/Walk/blend_position", last_direction)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x == 0:
			velocity.x = 0
		elif input_vector.y == 0:
			velocity.y = 0
		
		last_direction = input_vector
		update_direction()

		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO

	var speed_rate = velocity.length() / max_speed
	if speed_rate != Global.player_volume_level:
		Global.player_volume_level = speed_rate
	
	move_and_slide()
	
#	if is_action_just_pressed("interact") && interact():
#		return

func interact():
#	var areas = objectDetection.get_overlapping_areas()
#	if areas.size() > 0:
#		for area in areas:
#			Global.failed_interaction = false
#			if area.has_method('interact') && area.call('interact'):
#				if !Global.failed_interaction:
#					return true

	return false
	
func is_action_just_pressed(action):
	return Input.is_action_just_pressed(action)
