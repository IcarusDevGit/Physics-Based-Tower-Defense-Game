extends RigidBody2D

@export var BulletScene : PackedScene
@export var CasingScene : PackedScene

var EnemiesInRange = []

@export var BulletSpeed = 1000
var CasingSpeed = 500
var RecoilSpeed = 10
@export var RecoilPower = 10

# Position the gun returns to after shooting
@export var BaseGunPosition = Vector2.ZERO

var Active = false

@export var ShootSound = "res://Assets/Sounds/762x54r Single Isolated WAV.wav"
@export var ShootSoundVolume = -10 #be careful with putting this in the positives, it gets LOUD

func _ready():
	pass 



func _process(delta):
	if not EnemiesInRange.size() == 0:
		Active = true
	
	else:
		Active = false
	
	# Recoil control
	$Gun.position = $Gun.position.lerp(BaseGunPosition, delta * RecoilSpeed)
	
	if Active:
		$Gun.look_at(EnemiesInRange[0].global_position)



func Shoot():
	var Bullet = BulletScene.instantiate()
	get_tree().get_root().call_deferred("add_child", Bullet)
	
	Bullet.position = $Gun/Marker2D.global_position
		
	Bullet.rotation_degrees = $Gun.rotation_degrees
	
	Bullet.apply_impulse(
		Vector2(BulletSpeed, 0).rotated($Gun.rotation + rotation),
		
		Vector2.ZERO)
	
	# Recoil
	$Gun.position -= Vector2(10, 0).rotated($Gun.rotation)
	apply_impulse(Vector2(RecoilPower,0).rotated($Gun.global_rotation), $Gun.global_position)
	
	# Particles and muzzle flash
	$Gun/ShootingParticles.emitting = true
	$Gun/ShootingParticles.restart()
	$Gun/MuzzleFlash.visible = true
	$Gun/MuzzleFlash.play("default")
	
	# Sound
	var soundEffect = SoundEffect.new()
	get_tree().get_root().get_child(0).add_child(soundEffect)
	soundEffect.global_position = global_position
	soundEffect.PlaySound(ShootSound, ShootSoundVolume)
	
	# Create a casing
	var c = CasingScene.instantiate()
	var side_mod = (EnemiesInRange[0].global_position - self.position).x > 0
	var casing_direction = Vector2(0.3 + randf(), -1)
	if side_mod: casing_direction.x = -1 * casing_direction.x 
	get_tree().get_root().call_deferred("add_child", c)
	c.position = global_position + BaseGunPosition
	c.rotation_degrees = rotation_degrees
	c.apply_impulse(
		casing_direction * CasingSpeed, Vector2.ZERO
	)
	c.apply_torque_impulse(40)



func _on_range_body_entered(body):
	if body.is_in_group("Enemy"):
		EnemiesInRange.append(body)


func _on_range_body_exited(body):
	if body.is_in_group("Enemy"):
		EnemiesInRange.erase(body)


func _on_shooting_timer_timeout():
	if Active:
		Shoot()


func _on_muzzle_flash_animation_finished():
	$Gun/MuzzleFlash.visible = false
