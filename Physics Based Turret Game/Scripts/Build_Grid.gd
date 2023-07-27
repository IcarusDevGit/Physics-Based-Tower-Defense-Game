extends MultiMeshInstance2D

@export var build_grid_unit = 24
@export var instance_count = 1000

func _ready():
	# Create a grid to line up blocks when building stuff
	multimesh.instance_count = instance_count
	multimesh.visible_instance_count = instance_count
	for i in range(instance_count):
		var t = Transform2D(Vector2(1, 0), Vector2(0, 1),
			Vector2(i % 49 * build_grid_unit, (floor(i/49) * build_grid_unit))
		)
		multimesh.set_instance_transform_2d(i, t)

func _process(delta):
	visible = get_parent().build_mode
