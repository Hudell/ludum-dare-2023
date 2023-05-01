extends CharacterBody2D

var found_player = false

func _ready():
	$Exclamation.visible = false

func _physics_process(delta):
	if found_player:
		return

	if $PlayerDetector.can_see_player() && Global.player_volume_level >= 0.98:
		found_player = true
		$AnimationPlayer.play("wake")

func _on_player_detector_player_seen():
	Global.in_dog_range = true

func got_caught():
	Global.got_caught()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "wake":
		$Exclamation.visible = true
		$AnimationPlayer.play("bark")

func _on_exclamation_animation_finished():
	$Exclamation.visible = false

func _on_player_detector_player_lost():
	Global.in_dog_range = false
