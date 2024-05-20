extends CharacterBody2D

var is_enemy: bool = true
var player_nearby: bool = false

var health: int = 3
var vulnerable: bool = true
var speed: int = 170
var speed_multiplier: float = 1

signal projectile(pos, direction)

func _ready():
	if (randi() % 2) < 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos
	
func _process(_delta):
	if player_nearby == true:
		if (self.position.x - Globals.player_pos.x) < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

func _physics_process(delta):
	if player_nearby == true:
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed * speed_multiplier
		$AnimationPlayer.play("Run")
		var collision = move_and_collide(velocity * delta)
		var player: CharacterBody2D = find_parent("World").find_child("Player")
		if collision and collision.get_collider() == player:
			if "hit" in player:
				player.hit()
		

func hit():
	if vulnerable: 
		health -= 1
		vulnerable = false
		$Timers/HitTimer.start()
		get_node("AnimatedSprite2D").material.set_shader_parameter("progress", 1)
		speed_multiplier = 0.5
	if health <= 0:
		queue_free()

func _on_aggro_area_body_entered(_body):
	pass

func _on_aggro_area_body_exited(_body):
	pass # Replace with function body.


func _on_attack_area_body_exited(_body):
	player_nearby = false
	$AnimationPlayer.play("Idle")


func _on_hit_timer_timeout():
		vulnerable = true
		speed_multiplier = 1
		get_node("AnimatedSprite2D").material.set_shader_parameter("progress", 0)


func _on_nav_timer_timeout():
	$NavigationAgent2D.target_position = Globals.player_pos


func _on_attack_area_body_entered(body):
	if body.name == "Player":
		player_nearby = true

