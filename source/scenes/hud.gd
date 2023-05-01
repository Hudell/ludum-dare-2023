extends CanvasLayer

func _ready():
	Global.connect("player_volume_changed", Callable(self, "set_volume_level"))
	Global.connect("player_caught", Callable(self, "player_caught"))
	Global.connect("in_dog_range_changed", Callable(self, "player_in_dog_range"))
	
	set_volume_level(0)
	player_in_dog_range()
	
func _exit_tree():
	Global.disconnect("player_volume_changed", Callable(self, "set_volume_level"))
	Global.disconnect("player_caught", Callable(self, "player_caught"))
	Global.disconnect("in_dog_range_changed", Callable(self, "player_in_dog_range"))

func set_volume_level(volume):
	$DogGauge/Gauge.size.x = 48 * volume

func player_caught():
	get_tree().paused = true
	$Caught.visible = true

func _on_restart_button_pressed():
	$Caught.visible = false
	Global.restart()

func player_in_dog_range():
	$DogGauge.visible = Global.in_dog_range
