extends CharacterBody2D

var can_primaryAction: bool = true
var can_secondaryAction: bool = true
var can_be_damaged: bool = true
var last_dir = 0
@onready var anim = get_node("AnimationPlayer") as AnimationPlayer
var radius = 5
var times = 0

signal player_primary_action(position, direction)
signal player_secondary_action(position, direction)

var PlayerHealth: float = 3
@export var Max_PlayerMoveSpeed: int = 150
var PlayerMoveSpeed: int = Max_PlayerMoveSpeed


# A Node-ok egyik callback metódusa, minden képkockában meghívodik
func _process(_delta):
	# A bevitelből meghatározzunk egy vektort, amelyik irányba szeretnénk menni
	var direction = Input.get_vector("left", "right", "up", "down")
	# Létrehozzuk a sebességvektort az irányvektor és a játékos mozgási 
	# sebességének szorzatából
	velocity = direction * PlayerMoveSpeed
	# A metódus amely elvégzi a mozgást 
	move_and_slide()
	# Elmentjük a játékos pozicióját egy Globális változóba
	Globals.player_pos = global_position
	
	# Létrehozunk egy változót, amely egy vektor lesz a egér poziciió és a 
	#játékos poziciója között
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	# Figyeljük hogy a játékos éppen nyomva tartja-e a lövés gombot és 
	# hogy tud-e éppen lőni
	if Input.is_action_pressed("primaryAction") and can_primaryAction:
		# Lövés után csak egy időzitőt követően fog tudni újra 
		# lőni a játékos
		can_primaryAction = false
		$Timers/PrimaryActionTimer.start()
		
		# Lekérjük a lehetséges létrehozási pontjait a nyílnak, ebből három 
		# előre elhelyezett létezik a íj vonalában
		var projectile_markers = $ProjectileStartPositions.get_children()
		# Kiválasztunk egyet véletlenszerűen
		var selected_projectile = projectile_markers[randi() % projectile_markers.size()]
		# Jelzünk a pályának, hogy megtörtént a nyílkilövés, a többit 
		# a pálya végzi
		player_primary_action.emit(selected_projectile.global_position, player_direction)
		
	if Input.is_action_just_pressed("secondaryAction") and can_secondaryAction and Globals.bomb_amount > 0:
		Globals.bomb_amount -= 1
		can_secondaryAction = false
		$Timers/SecondaryActionTimer.start()
		
		var projectile_markers = $ProjectileStartPositions.get_children()
		var selected_projectile = projectile_markers[randi() % projectile_markers.size()]
		player_secondary_action.emit(selected_projectile.global_position, player_direction)
		
	if Input.is_action_just_pressed("menu"):
		times += 1
		$Timers/QuitTimer.start()
		if times == 2:
			Globals.health = 100
			Globals.current_room = 0
			Globals.room_array.clear()
			Globals.bomb_amount = 2
			get_tree().change_scene_to_file("res://scenes/main/main.tscn")	
			times = 0
	
	
	
	#Sprite direction
	if direction == Vector2.RIGHT || direction.x > 0:
		last_dir = 1
		anim.play("RightRun")
	elif direction == Vector2.LEFT || direction.x < 0:
		last_dir = 2
		anim.play("LeftRun")
	elif direction == Vector2.UP:
		last_dir = 3
		anim.play("BackRun")
	elif direction == Vector2.DOWN:
		last_dir = 4
		anim.play("FrontRun")
	else:
		if last_dir == 1:
			anim.play("RightIdle")
		elif last_dir == 2:
			anim.play("LeftIdle")
		elif last_dir == 3:
			anim.play("BackIdle")
		elif last_dir == 4:
			anim.play("FrontIdle")
	
	#Orbiting Weapon around the player
	var mouse_pos = get_global_mouse_position()
	var player_pos = transform.origin 
	var _distance = player_pos.distance_to(mouse_pos) 
	var mouse_dir = (mouse_pos-player_pos).normalized()
	mouse_pos = player_pos + (mouse_dir * radius)
	$Weapon.look_at(mouse_dir * (radius+5) + player_pos)
	$Weapon.rotation_degrees += 0
	$Weapon.global_transform.origin = mouse_pos
	$ProjectileStartPositions.look_at(mouse_dir * (radius+5) + player_pos)
	$ProjectileStartPositions.global_transform.origin = mouse_pos
	
func _on_secondary_action_timer_timeout():
	can_secondaryAction = true

func _on_primary_action_timer_timeout():
	can_primaryAction = true
	
func hit():
	if can_be_damaged:
		can_be_damaged = false
		get_node("AnimatedSprite2D").material.set_shader_parameter("progress", 1)
	$Timers/HitTimer.start()
	Globals.health -= 10
	if Globals.health < 0:
		TransitionLayer.change_room()
		PlayerMoveSpeed = 0
		await get_tree().create_timer(1).timeout 
		PlayerMoveSpeed = 150
		get_tree().change_scene_to_file("res://scenes/level/hub.tscn")
		Globals.health = 100
		Globals.current_room = 0
		Globals.room_array.clear()
		Globals.bomb_amount = 2
		
func _on_hit_timer_timeout():
	get_node("AnimatedSprite2D").material.set_shader_parameter("progress", 0)
	can_be_damaged = true

func _on_quit_timer_timeout():
	times = 0
