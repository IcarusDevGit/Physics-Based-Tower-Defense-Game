extends RigidBody2D

@export var list_of_possible_textures: Array[Texture]

func _ready():
	# Select a random texture
	var i = randi() % len(list_of_possible_textures)
	$Texture.texture = list_of_possible_textures[i]
