extends LevelParent


func _ready():
	_set_camera_limit($PositionHelpers/CameraHelp,$PositionHelpers/CameraHelp2,player_camera)

#Front Doors------------
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
#func _on_back_door_player_entered_door(_body):
	#var tween = create_tween()
	#tween.tween_property(player,"PlayerMoveSpeed",0,0.5)
	#TransitionLayer.change_room()
	#await get_tree().create_timer(0.5).timeout 
	#var tween2 = create_tween()
	#tween2.tween_property(player,"PlayerMoveSpeed",150,0.5)
#
#func _on_back_door_player_near_door(_body):
	#camera_zoom_in()
#
#
#func _on_back_door_player_not_near_door(_body):
	#camera_zoom_out()
#-------------------------


func _on_controls_body_entered(_body):
	$Controls/Label/AnimationPlayer.play("Text")


func _on_controls_body_exited(_body):
	$Controls/Label/AnimationPlayer.play_backwards("Text")
