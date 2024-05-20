extends Node

func _init() -> void:
	randomize()

var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
var bomb_scene: PackedScene = preload("res://scenes/projectiles/bomb.tscn")
var item_scene: PackedScene = preload("res://scenes/items/coin.tscn")

func _ready():
	for container in get_tree().get_nodes_in_group("Container"):
		container.connect("open", _on_container_opened)
		
	for mob in get_tree().get_nodes_in_group("Mobs"):
		mob.connect("projectile", _on_mob_projectile)

func _on_container_opened(pos, direction):
	var item = item_scene.instantiate()
	item.position = pos
	item.direction = direction
	Globals.room_array[Globals.current_room].find_parent("World").get_node("Items").call_deferred("add_child", item)
	
func _on_mob_projectile(pos, direction):
	var projectile = projectile_scene.instantiate() as Area2D
	projectile.position = pos
	projectile.rotation_degrees = rad_to_deg(direction.angle()) 
	projectile.direction = direction
	$Projectiles.add_child(projectile)
	
func _on_player_player_primary_action(pos, dir):
	var projectile = projectile_scene.instantiate() as Area2D
	projectile.position = pos
	projectile.rotation_degrees = rad_to_deg(dir.angle()) 
	projectile.direction = dir
	$Projectiles.add_child(projectile)
	
func _on_player_player_secondary_action(pos, dir):
	var bomb = bomb_scene.instantiate() as RigidBody2D
	bomb.position = pos
	bomb.linear_velocity = dir * bomb.speed
	$Projectiles.add_child(bomb)
