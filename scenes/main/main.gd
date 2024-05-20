extends Node2D

# A Quit gomb megnyomására meghívódó funkció
func _on_quit_pressed():
	# Kilépés a játékból
	get_tree().quit()


# A Play game megnyomására meghívódó funkció
func _on_new_game_pressed():
	#A Scene Tree osztály segítségével átváltjuk az aktív jelenetet a 'hub' jelenetre
	get_tree().change_scene_to_file("res://scenes/level/hub.tscn")
