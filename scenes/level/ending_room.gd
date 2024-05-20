extends LevelParent


func _on_back_door_player_entered_door(_body):
	var tween = create_tween()
	tween.tween_property(player,"PlayerMoveSpeed",0,0.5)
	Globals.current_room -= 1
	player.global_position = Globals.room_array[Globals.current_room].get_node("PositionHelpers/PlayerLastRoomPos").global_position
	await TransitionLayer.change_room()
	_set_camera_limit(Globals.room_array[Globals.current_room].get_node("PositionHelpers/CameraHelp"),Globals.room_array[Globals.current_room].get_node("PositionHelpers/CameraHelp2"),player_camera)
	await get_tree().create_timer(0.5).timeout 
	var tween2 = create_tween()
	tween2.tween_property(player,"PlayerMoveSpeed",150,0.5)


func _on_back_door_player_near_door(_body):
	camera_zoom_in()


func _on_back_door_player_not_near_door(_ody):
	camera_zoom_out()


func _on_area_2d_body_entered(_body):
	pass
	#var tween = get_tree().create_tween()
	#tween.tween_property($Player/Camera2D,"zoom",Vector2(3,3),0.8)


func _on_area_2d_body_exited(_body):
	pass
	#var tween = get_tree().create_tween()
	#tween.tween_property($Player/Camera2D,"zoom",Vector2(2.8,2.8),0.8)


func _on_area_2d_2_body_entered(_body):
	Globals.health = 100
	Globals.current_room = 0
	Globals.room_array.clear()
	Globals.bomb_amount = 2
	await TransitionLayer.change_room()
	get_tree().change_scene_to_file("res://scenes/level/hub.tscn")
