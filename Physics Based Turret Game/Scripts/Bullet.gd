extends RigidBody2D

var Damage = 1



func _ready():
	pass

func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Wall"):
		queue_free()
		
	if body.is_in_group("Enemy"):
		body.Hit(Damage)
		queue_free()
