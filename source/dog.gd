extends CharacterBody2D

func _ready():
	$Exclamation.visible = false

func _physics_process(delta):
	if Global.player_volume_level >= 0.98:
		$PlayerDetector.monitoring = true
	else:
		$PlayerDetector.monitoring = false

func _on_player_detector_player_seen():
	$AnimationPlayer.play("wake")

func got_caught():
	Global.got_caught()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "wake":
		$Exclamation.visible = true
		$AnimationPlayer.play("bark")

func _on_exclamation_animation_finished():
	$Exclamation.visible = false
