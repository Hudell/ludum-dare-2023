extends CanvasLayer

func _ready():
	Global.connect("player_volume_changed", Callable(self, "set_volume_level"))
	Global.connect("player_caught", Callable(self, "player_caught"))
	Global.connect("in_dog_range_changed", Callable(self, "player_in_dog_range"))
	Global.connect("stage_complete", Callable(self, "show_success"))
	Global.connect("map_changed", Callable(self, "show_tutorial"))
	
	set_volume_level(0)
	player_in_dog_range()
	
func _exit_tree():
	Global.disconnect("player_volume_changed", Callable(self, "set_volume_level"))
	Global.disconnect("player_caught", Callable(self, "player_caught"))
	Global.disconnect("in_dog_range_changed", Callable(self, "player_in_dog_range"))
	Global.disconnect("stage_complete", Callable(self, "show_success"))
	Global.disconnect("map_changed", Callable(self, "show_tutorial"))

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

func _on_next_button_pressed():
	$Success.visible = false
	Global.next_stage()

func show_success():
	get_tree().paused = true
	$Success.visible = true
	
func _on_start_button_pressed():
	$Tutorial1.visible = false
	$Tutorial2.visible = false
	get_tree().paused = false

func show_tutorial():
	if Global.current_stage == 1:
		$Tutorial1.visible = true
	else:
		$Tutorial2.visible = true
	get_tree().paused = true
