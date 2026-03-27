extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Create a simple flat background for the slider
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.2, 0.2, 0.2, 0.5)  # dark gray, semi-transparent
	bg_style.border_color = Color(0, 0, 0)
	bg_style.border_width_top = 2
	bg_style.border_width_bottom = 2
	bg_style.border_width_left = 2
	bg_style.border_width_right = 2

	var fg_style = StyleBoxFlat.new()
	fg_style.bg_color = Color(0.0, 0.7, 0.0)  # green fill

	# Apply styles to HSlider
	add_theme_stylebox_override("bg", bg_style)  # track background
	add_theme_stylebox_override("fg", fg_style)  # filled portion
	
	# Get the bus index
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Connect the slider's value_changed signal to our handler
	self.value_changed.connect(_on_value_changed)
	
	# Optional: set initial slider value to match current bus volume
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	# Set the bus volume based on slider value
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
