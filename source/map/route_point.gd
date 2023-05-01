extends Marker2D

const is_route_point = true

@export_enum("None", "Down", "Left", "Right", "Up", "Free") var direction_to_face: String = "None"
@export var min_seconds_to_stay = 0
@export var max_seconds_to_stay = 0
@export var skip_chance = 0
