extends CharacterBody2D

var Gravity = 30
var TargetVelocity = Vector2.ZERO
var Speed = 15

var HP = 10
var KnockbackResistance = 50

@onready var Crystal = get_parent().get_node("Crystal")
@export var Explosion: PackedScene

var spawner #Reference to the spawner is needed so the next wave only starts when there are no enemies left

func _ready():
	$Sprite2D.play("default")
	$Sprite2D.set_frame_and_progress(randi() % 4, 0) 
	var direction = Crystal.global_position - global_position
	if direction.x < 0:
		$Sprite2D.flip_h = true


func _process(delta):
	
	if not is_on_floor():
		TargetVelocity.y += Gravity
	
	var CrystalPosition = Crystal.global_position - global_position
	
	TargetVelocity.x = lerp(TargetVelocity.x, CrystalPosition.normalized().x * Speed, delta * KnockbackResistance)
	
	velocity = TargetVelocity
	
	move_and_slide()


func Hit(Damage):
	HP -= Damage
	TargetVelocity -= (Crystal.global_position - global_position).normalized() * Damage * 100
	if HP <= 0:
		Die()

func Die():
	spawner.EnemiesAlive.erase(self) #tells the spawner this enemy has died
	
	# Spawn an explosion on death
	var e = Explosion.instantiate()
	get_parent().add_child(e)
	e.global_position = global_position
	queue_free()

func max_vector(vector1: Vector2, vector2: Vector2) -> Vector2:
	if vector1.length() > vector2.length():
		return vector1
	return vector2
