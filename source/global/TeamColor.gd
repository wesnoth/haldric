extends Node

const TEAM_SHADER = preload("res://graphics/shaders/team_colors.shader")
const FLAG_SHADER = preload("res://graphics/shaders/team_flag.shader")

var base_color_map := [
	Color("F49AC1"),
	Color("3F0016"),
	Color("55002A"),
	Color("690039"),
	Color("7B0045"),
	Color("8C0051"),
	Color("9E005D"),
	Color("B10069"),
	Color("C30074"),
	Color("D6007F"),
	Color("EC008C"),
	Color("EE3D96"),
	Color("EF5BA1"),
	Color("F172AC"),
	Color("F287B6"),
	Color("F6ADCD"),
	Color("F8C1D9"),
	Color("FAD5E5"),
	Color("FDE9F1")
]

var base_flag_color := []

var team_color_data := {
	"red": [Color("FF0000"), Color("FFFFFF"), Color("000000"), Color("FF0000")],
	"blue": [Color("2E419B"), Color("FFFFFF"), Color("0F0F0F"), Color("0000FF")],
	"green": [Color("62B664"), Color("FFFFFF"), Color("000000"), Color("00FF00")],
	"purple": [Color("93009D"), Color("FFFFFF"), Color("000000"), Color("FF00FF")],
	"black": [Color("5A5A5A"), Color("FFFFFF"), Color("000000"), Color("000000")],
	"white": [Color("E1E1E1"), Color("FFFFFF"), Color("1E1E1E"), Color("FFFFFF")],
	"brown": [Color("945027"), Color("FFFFFF"), Color("000000"), Color("AA4600")],
	"orange": [Color("FF7E00"), Color("FFFFFF"), Color("0F0F0F"), Color("FFAA00")],
	"teal": [Color("30CBC0"), Color("FFFFFF"), Color("000000"), Color("00F0C8")]
}

func _ready() -> void:
	_initialize_flag_colors()

func generate_team_shader(team_color: String) -> ShaderMaterial:
	return _generate_shader_impl(team_color, TEAM_SHADER, base_color_map)

func generate_flag_shader(team_color: String) -> ShaderMaterial:
	return _generate_shader_impl(team_color, FLAG_SHADER, base_flag_color)

func _generate_shader_impl(team_color: String, shader: Shader, base: Array) -> ShaderMaterial:
	var team_data = team_color_data[team_color]

	var mat := ShaderMaterial.new()
	mat.shader = shader

	var color_map := new_color_map(team_data, base)

	var i := 1
	for key in color_map:
		mat.set_shader_param("base%d" % i, key)
		mat.set_shader_param("color%d" % i, color_map[key])

		i += 1

	return mat

func new_color_map(team_data: Array, base_color: Array) -> Dictionary:
	var color_map := {}

	var new_avg: Color = team_data[0]
	var new_max: Color = team_data[1]
	var new_min: Color = team_data[2]

	var temp_color: Color = base_color[0]
	var temp_avg = (temp_color.r + temp_color.g + temp_color.b) / 3.0

	for color in base_color:
		var color_avg: float = (color.r + color.g + color.b) / 3.0

		var r: float
		var g: float
		var b: float

		if color_avg <= temp_avg:
			var ratio: float = color_avg / temp_avg

			r = ratio * new_avg.r + (1 - ratio) * new_min.r
			g = ratio * new_avg.g + (1 - ratio) * new_min.g
			b = ratio * new_avg.b + (1 - ratio) * new_min.b
		else:
			var ratio: float = (1.0 - color_avg) / (1.0 - temp_avg)

			r = ratio * new_avg.r + (1 - ratio) * new_max.r
			g = ratio * new_avg.g + (1 - ratio) * new_max.g
			b = ratio * new_avg.b + (1 - ratio) * new_max.b

		color_map[color] = Color(min(r, 1), min(g, 1), min(b, 1))

	return color_map

func _initialize_flag_colors() -> void:
	var format_str := "00%02X00"

	for i in 255:
		var new_color = format_str % [(i + 1)]

		# Why C8 you ask? Who knows, I hope whoever made this palette does.
		if new_color == "00C800":
			continue

		base_flag_color.push_back(Color(new_color))

	base_flag_color.push_back(Color("00C800"))
	base_flag_color.invert()
