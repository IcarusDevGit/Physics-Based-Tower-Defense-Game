extends Node

@export var tower1: PackedScene
@export var tower2: PackedScene
@export var block1: PackedScene
@export var block2: PackedScene

@onready var buildable_towers = [block1, block2, tower1, tower2]
# Offset for each buildable tower (only used for fat block & tower 2 so it lines up with the other blocks)
var buildable_towers_offset = [Vector2.ZERO, Vector2(36, 0), Vector2.ZERO, Vector2(12, 12)]

@onready var build_menu = $Build_Menu
var build_mode = false
var index_of_currently_selected_tower = 0

func _ready():
	pass

func _process(delta):
	if build_mode:
		# If in build mode and player clicks -> build a tower 
		if Input.is_action_just_pressed("Left_Click"):
			build_tower(
				buildable_towers[index_of_currently_selected_tower],
				get_viewport().get_mouse_position()
			)
	
	# Press B to enter/exit build mode (or enter)
	if Input.is_action_just_pressed("Enter_Build_Mode"):
		build_mode = !build_mode
		$Tutorial1.visible = !$Tutorial1.visible
		$Build_Menu.visible = !$Build_Menu.visible
	
	# Switch which tower to build
	if Input.is_action_just_pressed("Option1"):
		select_tower(0)
	if Input.is_action_just_pressed("Option2"):
		select_tower(1)
	if Input.is_action_just_pressed("Option3"):
		select_tower(2)
	if Input.is_action_just_pressed("Option4"):
		select_tower(3)
	if Input.is_action_just_pressed("Scroll_Down"):
		select_tower(index_of_currently_selected_tower + 1)
	if Input.is_action_just_pressed("Scroll_Up"):
		select_tower(index_of_currently_selected_tower - 1)

func select_tower(i: int):
	if i < 0: i = len(buildable_towers) - 1
	index_of_currently_selected_tower = i % len(buildable_towers)
	$Build_Menu.currently_selected = index_of_currently_selected_tower

func build_tower(which: PackedScene, at: Vector2):
	at = at.snapped(Vector2(24, 24)) + buildable_towers_offset[index_of_currently_selected_tower]
	at.y = 0 #This makes the towers and blocks always fall from the sky, opposed to appearing at the cursor
	var a = which.instantiate()
	add_child(a)
	a.position = at

func _on_crystal_body_entered(body):
	if body.is_in_group("Enemy"):
		print("game over")
















#thbrave was here
#ghost_wave was here <3
