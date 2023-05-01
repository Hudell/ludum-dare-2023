extends Area2D

var player = null:
	get:
		return player
	set(value):
		player = value

signal player_seen

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	player = body
	emit_signal("player_seen")

func can_see_player():
	return player != null

func _on_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	player = null
