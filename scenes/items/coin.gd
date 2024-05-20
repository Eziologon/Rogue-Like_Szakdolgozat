extends Area2D

var rotation_speed: int = 4
var type = "coin"

var direction: Vector2
var distance: int = randi_range(30,40)

func _ready():
	var target_pos = position + direction * distance
	var movement_tween = create_tween()
	movement_tween.set_parallel()
	movement_tween.tween_property(self, "position", target_pos, 0.5)
	movement_tween.tween_property(self, "scale", Vector2(1,1), 0.3).from(Vector2(0,0))
	

func _on_body_entered(body):
	if type == "coin":
		if randi() % 100 + 1 > 30:
			Globals.health += 10
		if randi() % 100 + 1 > 80:
			Globals.bomb_amount += 1 
	if body.collision_layer == 1:
		queue_free()
