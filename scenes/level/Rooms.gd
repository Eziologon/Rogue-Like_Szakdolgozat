extends Node2D

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 1
const RIGHT_WALL_TILE_INDEX: int = 3
const LEFT_WALL_TILE_INDEX: int = 0

# A kezdő szobákért felelős tömb
const SPAWN_ROOMS: Array = [preload("res://scenes/level/base_room_1.tscn")]
# A speciális szobákért felelős tömb
const SPECIAL_ROOMS: Array = [preload("res://scenes/level/item_room.tscn")]
# A köztest felelős tömb
const INTERMEDIATE_ROOMS: Array = [preload("res://scenes/level/base_room_2.tscn"), preload("res://scenes/level/base_room_3.tscn"), preload("res://scenes/level/base_room_4.tscn")]
# Az utolsó szobákért felelős tömb
const END_ROOMS: Array = [preload("res://scenes/level/ending_room.tscn")]
# A főellenfél szobájért felelős tömb
const BOSS_ROOMS: Array = [preload("res://scenes/level/boss_room.tscn")]

# Egy generált pálya hossza szobákban
@export var num_levels: int = 8
# Amikor már készen áll a jelenet hierachia, akkor eltároljuk a játékost, hogy jó később jó kezdőpontra tudjuk tenni
@onready var player: CharacterBody2D = get_parent().get_node("Player")
# Létezik-e már speciális szoba 
var special_room_spawned: bool 
var random_number: int = randi_range(3,4)

# A jelenet létrejöttekor meghívódó callback függvény
func _ready() -> void:
	# Mivel nem létezik még speciális szoba így a változóját hamisra állítjuk
	special_room_spawned = false
	# Elkezdjük a világgenerálást
	spawn_rooms()
	# A szobák számát későbbi hivatkozra eltároljuk egy globális változóban
	Globals.number_of_rooms = get_parent().get_node("Rooms").get_child_count()

# A világ generálást végző metódus
func spawn_rooms() -> void:
	
	var previous_room: Node2D

	# Annyiszor szeretnék hozzáadni szobát amennyi a pálya teljes hossza
	for i in num_levels:
		# Ebben a változóban fogjuk eltárolni az éppen létrejövő szobát
		var room: Node2D
		
		# Amennyiben ez az első szoba
		if i == 0:
			# A kezdő szobák listájából kiválasztunk egyet véletlenszerűen és létrehozzuk azt
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			# Megadjuk a játékos kezdőpozicióját a szobába található jelző segítségével 
			player.position = room.get_node("PositionHelpers").get_node("PlayerSpawnPos").position
			# Hozzáadjuk a létrejött szobát egy globális tömbbe amely az összes szobát tárolja
			Globals.room_array.append(room)
		
		# Ha nem az első szoba
		else:
			# Ha az utolsó szoba
			if i == num_levels - 1:
				# A végső szobák listájából kiválasztunk egyet véletlenszerűen és létrehozzuk azt
				room =  END_ROOMS[randi() % END_ROOMS.size()].instantiate()
				# Hozzáadjuk a létrejött szobát egy globális tömbbe amely az összes szobát tárolja
				Globals.room_array.append(room)
			# Ha az utolsó előtti szoba
			elif i == num_levels - 2:
				# A főellenséget tartalmazó szobák listájából kiválasztunk egyet véletlenszerűen és létrehozzuk azt
				room =  BOSS_ROOMS[randi() % BOSS_ROOMS.size()].instantiate()
				# Hozzáadjuk a létrejött szobát egy globális tömbbe amely az összes szobát tárolja
				Globals.room_array.append(room)
			# A köztes szobák esetén
			else:
				# Amennyiben még nincs ilyen szoba, véletlenszerűen választunk neki egy pozíciót
				if i == num_levels - random_number and not special_room_spawned:
					# A speciális szobák listájából kiválasztunk egyet véletlenszerűen és létrehozzuk azt
					room =  SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
					# Hozzáadjuk a létrejött szobát egy globális tömbbe amely az összes szobát tárolja
					Globals.room_array.append(room)
					# Mivel már létrejött a speciális szoba, így ezt igazra állítjuk
					special_room_spawned = true
				# Bármely más esetben már csak a köztes szobák jöhetnek létre
				else:
					# A köztes szobák listájából kiválasztunk egyet véletlenszerűen és létrehozzuk azt
					room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
					# Hozzáadjuk a létrejött szobát egy globális tömbbe amely az összes szobát tárolja
					Globals.room_array.append(room)
			
			var previous_room_tilemap: TileMap = previous_room.get_node("Ground/NavigationRegion2D/TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Ground/FrontDoor")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP 
			
			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height + 3: 
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y), LEFT_WALL_TILE_INDEX, Vector2i(0,2))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y), FLOOR_TILE_INDEX, Vector2i(3,2))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y), FLOOR_TILE_INDEX, Vector2i(3,2))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y), RIGHT_WALL_TILE_INDEX, Vector2i(5,1))
			
			
			var room_tilemap: TileMap = room.get_node("Ground/NavigationRegion2D/TileMap") 
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE 
		
		add_child(room)
		previous_room = room
