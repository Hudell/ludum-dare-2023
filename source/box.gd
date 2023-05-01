extends Sprite2D

func _on_player_detector_player_seen():
	Global.got_box = true
	queue_free()
