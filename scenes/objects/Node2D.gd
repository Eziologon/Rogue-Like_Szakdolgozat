extends StaticBody2D

signal player_entered_door(body)
signal player_near_door(body)
signal player_not_near_door(body)

func _on_player_near_body_entered(body):
	$AnimatedSprite2D.play("Open")
	player_near_door.emit(body)


func _on_player_near_body_exited(body):
	$AnimatedSprite2D.play_backwards("Open")
	player_not_near_door.emit(body)


func _on_scene_transition_area_body_entered(body):
		player_entered_door.emit(body)
