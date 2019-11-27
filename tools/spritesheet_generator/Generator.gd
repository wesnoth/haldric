extends Control

const ROOT = "res://tools/spritesheet_generator/"
const LOADER_PATH = ROOT + "Loader.gd"

var Loader = preload(LOADER_PATH).new()

var image_size := Vector2()

export var width := 0

onready var width_line := $CenterContainer/VBoxContainer/HBoxContainer/Width/LineEdit
onready var height_line := $CenterContainer/VBoxContainer/HBoxContainer/Height/LineEdit
onready var sheet_width := $CenterContainer/VBoxContainer/SheetWidth/LineEdit
onready var name_line := $CenterContainer/VBoxContainer/Name/LineEdit

func _ready() -> void:
	width_line.text = str(72)
	height_line.text = str(72)
	sheet_width.text = str(10)
	name_line.text = "grass"

func _on_Button_pressed() -> void:
	var file_data := Loader.load_dir(ROOT + "images", ["png"]) as Array

	image_size = Vector2(float(width_line.text), float(height_line.text))
	width = int(sheet_width.text)

	var dimensions = Vector2(width, file_data.size() / width + 1)

	var sheet_image := Image.new()
	var sheet_info := SheetInfo.new()

	sheet_image.create(dimensions.x * image_size.x, dimensions.y * image_size.y, false, Image.FORMAT_RGBA8)
	sheet_image.fill(Color("00000000"))


	var x := 0
	var y := 0

	file_data.sort_custom(self, "sort_image_info")
	file_data.invert()

	for file in file_data:

		var image := file.data.get_data() as Image

		# make dict entry
		sheet_info.data[file.id] = {}
		sheet_info.data[file.id].id = file.id
		sheet_info.data[file.id].rect = Rect2(Vector2(x * image_size.x, y * image_size.y), image.get_size())
		sheet_info.data[file.id].offset = image.get_used_rect().position

		var rect = image.get_used_rect()

		for p_y in rect.size.y:
			for p_x in rect.size.x:

				image.lock()
				var color = image.get_pixel(p_x + rect.position.x, p_y + rect.position.y)
				image.unlock()

				sheet_image.lock()
				sheet_image.set_pixel(x * image_size.x + p_x, y * image_size.y + p_y, color)
				sheet_image.unlock()
		x += 1
		if x == width:
			x = 0
			y += 1

	sheet_image.save_png(ROOT + "output/" + name_line.text + ".png")
	ResourceSaver.save(ROOT + "output/" + name_line.text + ".tres", sheet_info)

func sort_image_info(a: Dictionary, b: Dictionary) -> bool:
	var a_image := a.data.get_data() as Image
	var b_image := b.data.get_data() as Image

	return a_image.get_used_rect().size.length() < b_image.get_used_rect().size.length()
