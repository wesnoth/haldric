extends Node2D

var HexGrid = preload("./HexGrid.gd").new()

onready var selector = get_node("Interface/Selector")
onready var area_coords = get_node("Interface/Selector/AreaCoords")
onready var hex_coords = get_node("Interface/Selector/HexCoords")


func _ready():
	HexGrid.hex_scale = Vector2(72, 72)
	

func _unhandled_input(event):
	if event.position:
		var relative_pos = self.transform.affine_inverse() * event.position
		# Display the coords used
		if area_coords != null:
			area_coords.text = str(relative_pos)
		if hex_coords != null:
			hex_coords.text = str(HexGrid.get_hex_at(relative_pos).axial_coords)
		
		# Snap the highlight to the nearest grid cell
		if selector != null:
			selector.position = HexGrid.get_hex_center(HexGrid.get_hex_at(relative_pos))
