extends Node2D
class_name LevelParent

@onready var player_camera: Camera2D = find_parent("World").find_child("Camera2D")
@onready var player: CharacterBody2D = find_parent("World").find_child("Player")
var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
var item_scene: PackedScene = preload("res://scenes/items/coin.tscn")

func camera_zoom_in():
	var tween = get_tree().create_tween()
	tween.tween_property(player_camera,"zoom",Vector2(3.4,3.4),0.4)
	
	
func camera_zoom_out():
	var tween = get_tree().create_tween()
	tween.tween_property(player_camera,"zoom",Vector2(2.8,2.8),0.4)
	
	
func _set_camera_limit(pos1,pos2,camera):
	camera.limit_bottom = pos1.global_position.y
	camera.limit_left = pos1.global_position.x
	camera.limit_right = pos2.global_position.x
	camera.limit_top = pos2.global_position.y
