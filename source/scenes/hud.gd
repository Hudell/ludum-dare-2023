extends CanvasLayer

func _ready():
	Global.connect("player_volume_changed", Callable(self, "set_volume_level"))
	
func _exit_tree():
	Global.disconnect("player_volume_changed", Callable(self, "set_volume_level"))

func set_volume_level(volume):
	$DogGauge/Gauge.size.x = 48 * volume
