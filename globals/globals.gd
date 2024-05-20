extends Node

# Egy saját Signal, amely jelzést küldd a UI-nak ha változik az érték
signal stat_change

# A bombák mennyiségét tároló változó
var bomb_amount = 2:
	# Meghívódik ha változik a változó értéke
	set(value):
		# Egyenlővé tesszük a változót az értékkel 
		# amivel változtatni szeretnénk
		bomb_amount = value
		# Jelzést küldünk értékváltozás hatására
		stat_change.emit()	

# A játékos sebezhetőségért felelős változó
var player_vulnerable: bool = true
# A játékos életerejéért felelős változó
var health = 100:
	# Meghívódik ha megpróbáljuk kiolvasni a változó értékét
	get:
		# Mindig az eltárolt életerőt adja vissza
		return health
	# Meghívódik ha változik a változó értéke
	set(value):
		# Leellenőrizzük hogy amire szeretnénk változtatni 
		# az nagyobb-e mint az előző érték
		if value > health:
			# Ha igen, azaz nőtt az életerő, akkor azt csak akkor tesszük
			# egyenlővé a változóval, ha az kisebb mint 100
			health = min(value, 100)
		# Abban az esetben viszont ha csökkenne az életerő	
		else:
			# Megnézzük először hogy a játékos éppen sebezhető-e
			if player_vulnerable:
				# Ha igen, akkor beállítjuk az új értéke az életerőt, 
				# és elindítjuk a sebezhetetlenségért felelős időzítőt
				health = value
				player_vulnerable = false
				player_invulnerable_timer()
		# Jelzést küldünk értékváltozás hatására
		stat_change.emit()

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true
	
var player_pos: Vector2

#Room Stuff
var room_array: Array 
var number_of_rooms: int 
var current_room: int = 0
