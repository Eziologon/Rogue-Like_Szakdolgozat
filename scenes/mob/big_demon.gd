extends CharacterBody2D

var is_enemy: bool = true
var player_nearby: bool = false

var health: int = 5
var vulnerable: bool = true
var speed: int = 100
var speed_multiplier: float = 1

signal projectile(pos, direction)

func _ready():
	if (randi() % 2) < 1:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	
# A Node-ok egyik callback metódusa, minden képkockában meghívodik
func _process(delta):
	# A szörny csak akkor aktív ha játékos elég közel van hozzá
	if player_nearby == true:
		# Megvizsgáljuk hogy a játékoshoz képest milyen irányban kell mozognia, 
		# így a folyamatosan jó irányba forgatjuk a textúráját
		if (self.position.x - Globals.player_pos.x) < 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		# A játékoshoz hasonló módon létrehozunk egy irányvektor, 
		# amely a játékos fele fog mutatni
		var direction = (Globals.player_pos - global_position).normalized()
		# Sebességvektorát létrehozzuk az irányvektorból és a démon mozgási sebessségéből
		velocity = direction * speed * speed_multiplier
		# Elindítjuk a futás animációját a démonnak
		$AnimationPlayer.play("Run")
		
		# Eltároljuk a mozgásból jövő összes információt egy változóban
		var collision = move_and_collide(velocity * delta)
		# Létrehozunk egy referenciát a játékosra
		var player: CharacterBody2D = find_parent("World").find_child("Player")
		# Ha valamivel érintkezik a szörny, akkor megvizsgáljuk,
		# hogy amivel érintkezik az a játékos-e
		if collision and collision.get_collider() == player:
			if "hit" in player:
				# Ha igen, akkor meghívjuk a játékos megsebződését jelentő metódust
				player.hit()
	
func hit():
	if vulnerable: 
		health -= 1
		vulnerable = false
		$Timers/HitTimer.start()
		get_node("Sprite2D").material.set_shader_parameter("progress", 1)
		speed_multiplier = 0.5
	if health <= 0:
		queue_free()


func _on_attack_area_body_entered(body):
	if body.name == "Player":
		player_nearby = true


func _on_attack_area_body_exited(_body):
	pass


func _on_hit_timer_timeout():
	vulnerable = true
	speed_multiplier = 1
	get_node("Sprite2D").material.set_shader_parameter("progress", 0)


func _on_aggro_area_body_exited(_body):
	player_nearby = false
	$AnimationPlayer.play("Idle")
