extends Node2D

@export var spacing = 32
@export var select_speed = 10

var build_options = [
	"Small Block",
	"Fat Block",
	"Brave Turret",
	"Wave Turret"
]

var currently_selected = 0

func _ready():
	# Create menu list
	for i in range(len(build_options)):
		var l = Label.new()
		add_child(l)
		l.position = Vector2(32, i * spacing)
		l.text = build_options[i]

func _process(delta):
	$Select.position = $Select.position.lerp(Vector2(8, 4 + currently_selected * spacing), delta * select_speed)
