extends LevelParent

#Frpnt Doors---------------
func _on_front_door_player_entered_door(_body):
	var tween = create_tween()
	tween.tween_property(player,"PlayerMoveSpeed",0,0.5)
	await TransitionLayer.change_room()
	Globals.current_room += 1
	player.global_position = Globals.room_array[Globals.current_room].get_node("PositionHelpers/PlayerEntrancePos").global_position
	_set_camera_limit(Globals.room_array[Globals.current_room].get_node("PositionHelpers/CameraHelp"),Globals.room_array[Globals.current_room].get_node("PositionHelpers/CameraHelp2"),player_camera)
	await get_tree().create_timer(0.5).timeout 
	var tween2 = create_tween()
	tween2.tween_property(player,"PlayerMoveSpeed",150,0.5)


func _on_front_door_player_near_door(_body):
	camera_zoom_in()


func _on_front_door_player_not_near_door(_body):
	camera_zoom_out()
#-------------------------

#Back Doors---------------
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


func _on_back_door_player_not_near_door(_body):
	camera_zoom_out()
#-------------------------
