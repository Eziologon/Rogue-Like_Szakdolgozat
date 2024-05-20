extends CanvasLayer

# A metódus amelyet meghívhatunk bármely jelenetből
func change_room() -> void:
	# Elindítjuk a fekete átmenetért felelős animációt
	$AnimationPlayer.play("fade_to_black")
	# Megvárjuk hogy ez lejátszódjon
	await $AnimationPlayer.animation_finished
	#Elindítjuk az animációt visszafele, így eltűnik a fekete átmenet
	$AnimationPlayer.play_backwards("fade_to_black")
