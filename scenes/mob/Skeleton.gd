extends CharacterBody2D

var is_enemy: bool = true
var player_nearby: bool = false
var player_in_attack_range: bool = false
var can_shoot: bool = true
var pos1_use: bool = true

var health: int = 3
var vulnerable: bool = true

signal projectile(pos, direction)

func _ready():
	if (randi() % 2) < 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	

func _process(_delta):
	if player_nearby == true:
		if (self.position.x - Globals.player_pos.x) < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		
	if player_in_attack_range == true:
		$ProjectileSpawnPositions.look_at(Globals.player_pos)
		if can_shoot:
			var marker_node = $ProjectileSpawnPositions.get_child(pos1_use)
			pos1_use = not pos1_use
			var pos: Vector2 = marker_node.global_position
			var direction: Vector2 = (Globals.player_pos - global_position).normalized()
			projectile.emit(pos, direction)
			$Timers/ProjectileTimer.start()
			can_shoot = false


func hit():
	if vulnerable: 
		health -= 1
		vulnerable = false
		$Timers/HitTimer.start()
		get_node("AnimatedSprite2D").material.set_shader_parameter("progress", 1)
	if health <= 0:
		queue_free()

func _on_notice_area_body_entered(body):
	if body.name == "Player":
		player_in_attack_range = true


func _on_notice_area_body_exited(_body):
	player_in_attack_range = false


func _on_attack_area_body_entered(body):
	if body.name == "Player":
		player_nearby = true


func _on_attack_area_body_exited(_body):
	player_nearby = false


func _on_projectile_timer_timeout():
	can_shoot = true


func _on_hit_timer_timeout():
		vulnerable = true
		get_node("AnimatedSprite2D").material.set_shader_parameter("progress", 0)
