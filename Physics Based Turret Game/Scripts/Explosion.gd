extends Node2D

var Precision = 128
var Radius = 100
var Force = 0.5
var Raycasts = []
var has_exploded = false

func _ready():
	#Sound effect
	var soundFX = SoundEffect.new()
	get_tree().get_root().get_child(0).add_child(soundFX)
	soundFX.global_position = global_position
	soundFX.PlaySound("res://Assets/Sounds/Explosion 8 - Sound effects Pack 2.wav", 10, 0.8)
	
	for i in range(Precision):
		# Create raycast in every direction
		var a = RayCast2D.new()
		add_child(a)
		var angle = 2 * PI / Precision * i
		a.target_position = Vector2.ONE.rotated(angle) * Radius
		
		# Set raycast to collide with rigidbodies on layer 3, 2, 1
		a.collision_mask = 7
		
		Raycasts.append(a)

func _process(delta):
	if !has_exploded:
		$ExplosionParticles.emitting = true
		for ray in Raycasts:
			# Explode (apply force to objects around)
			var explosion_victim = ray.get_collider()
			if explosion_victim is RigidBody2D:
				explosion_victim.apply_impulse((explosion_victim.global_position - global_position) * Force, Vector2.ZERO)
		has_exploded = true

func _on_lifetime_timeout():
	queue_free()
