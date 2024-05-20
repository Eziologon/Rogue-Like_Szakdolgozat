extends Node2D

var is_near_tree: bool = false

func _ready():
	$Player/Weapon.visible = false
	$Player/Camera2D.zoom = Vector2(1.6, 1.6)
	$Player/Camera2D.limit_top = 0
	$Player/Camera2D.limit_bottom = 703
	$Player/Camera2D.limit_left = 0
	$Player/Camera2D.limit_right = 1250

func _process(_delta):
	if is_near_tree and Input.is_action_just_pressed("start"):
		await TransitionLayer.change_room()
		get_tree().change_scene_to_file("res://scenes/level/world.tscn")
		

func _on_player_near_player_entered():
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D,"zoom",Vector2(2,2),0.8)
	$Press/AnimationPlayer.play("Text")
	is_near_tree = true


func _on_player_near_player_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D,"zoom",Vector2(1.6,1.6),0.8)
	is_near_tree = false
	$Press/AnimationPlayer.play_backwards("Text")
	
