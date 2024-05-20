extends CanvasLayer

var blue: Color = Color("0C56BB")
var red: Color = Color(0.9, 0, 0, 1)

@onready var bomb_label: Label = $AmmoCounter/VBoxContainer/Label
@onready var bomb_icon: TextureRect = $AmmoCounter/VBoxContainer/TextureRect
@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar

func _ready():
	Globals.connect("stat_change", update_stat_text)
	update_bomb_text()
	update_health_text()


func update_bomb_text():
	bomb_label.text = str(Globals.bomb_amount)
	update_color(Globals.bomb_amount,bomb_label,bomb_icon)
	
	
func update_health_text():
	health_bar.value = Globals.health
	

func update_stat_text():
	update_bomb_text()
	update_health_text()
	
	
func update_color(amount: int, label: Label, icon: TextureRect) -> void:
	if amount <=0:
		label.modulate = red
		icon.modulate = red
	else:
		label.modulate = blue
		icon.modulate = blue
