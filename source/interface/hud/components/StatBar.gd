extends VBoxContainer

export var bar_color := Color("ffffff")

onready var stat_label := $StatLabel as Label
onready var bar := $TextureProgress as TextureProgress
onready var value_label := $ValueLabel as Label

func _ready() -> void:
	stat_label.text = name
	bar.tint_progress = bar_color

func update_stat(current: int, maximum: int) -> void:
	value_label.text = "%d / %d" % [current, maximum]
	bar.max_value = maximum
	bar.value = current

func clear() -> void:
	value_label.text = "-"
