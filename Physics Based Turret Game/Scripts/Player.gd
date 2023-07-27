extends CharacterBody2D



var Speed = 350
var JumpPower = -850
var Gravity = 30
var TargetVelocity = Vector2.ZERO
var BulletSpeed = 1000

@export var BulletScene: PackedScene

@onready var Towers = [
	preload("res://Scenes/tower_1.tscn")
	
	
	
	
]


func _physics_process(delta):
	var Motion = Vector2.ZERO
	
	if Input.is_action_just_pressed("Jump"):
		TargetVelocity.y = JumpPower
	
	if Input.is_action_pressed("Right"):
		Motion.x += 1
	
	if Input.is_action_pressed("Left"):
		Motion.x -= 1
	
	TargetVelocity.x = Motion.x * Speed
	
	if not is_on_floor():
		TargetVelocity.y +=  Gravity
	
	velocity = TargetVelocity
		
	move_and_slide()
	
	
	$Gun.look_at(get_global_mouse_position())
	
	
	if Input.is_action_just_pressed("Shoot"):
		Shoot()
	
	if Input.is_action_just_pressed("Build"):
		Build()





func Shoot():
	var Bullet = BulletScene.instantiate()
	get_tree().get_root().call_deferred("add_child", Bullet)
	
	Bullet.position = $Gun/Marker2D.global_position
		
	Bullet.rotation_degrees = $Gun.rotation_degrees
	
	Bullet.apply_impulse(
		Vector2(BulletSpeed, 0).rotated($Gun.rotation),
		
		Vector2.ZERO)





func Build():
	var Tower = Towers.pick_random().instantiate()
	get_tree().get_root().call_deferred("add_child", Tower)
	
	Tower.position = $Gun/Marker2D.global_position
