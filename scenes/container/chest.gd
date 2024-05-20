extends ItemContainer

func hit():
	if not opened:
		$AnimationPlayer.play("Open")
		opened = true
		await get_tree().create_timer(0.5).timeout 
		for i in range(randi() % 10):
			var pos = $SpawnPositions.get_child(randi()%$SpawnPositions.get_child_count()).global_position
			open.emit(pos, current_direction)

