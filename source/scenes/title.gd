extends Control

func _ready():
	$Buttons/Play.grab_focus()

func _process(delta):
	pass

func _on_play_button_button_up():
	Global.new_game()
	get_tree().change_scene_to_file("res://source/game.tscn")

func _on_exit_button_button_up():
	get_tree().quit()
