extends Path2D

export var bend := 0.3
export var color := Color(255, 0, 0, 0.5)
export var width := 20

var path := [] setget _path_updated

onready var follow := $Follow as PathFollow2D
onready var tween := $Tween as Tween
onready var remote_control := $Follow/RemoteControl as RemoteTransform2D

func _draw() -> void:
	if path.size() < 2:
		return

	curve.clear_points()

	for i in path.size():
		# Control points
		var cp1 := Vector2(0, 0)
		var cp2 := Vector2(0, 0)

		var current: Vector2 = path[i].position

		# Method adapted from http://scaledinnovation.com/analytics/splines/aboutSplines.html
		# Skip control points for the first and last points since we need two adjacent points to calculate them.
		if i > 0 and i < path.size() - 1:
			var prev: Vector2 = path[i - 1].position
			var next: Vector2 = path[i + 1].position

			# Distance from prev point to current and from current to next
			var d01 := sqrt(pow(current.x - prev.x, 2) + pow(current.y - prev.y, 2))
			var d12 := sqrt(pow(next.x - current.x, 2) + pow(next.y - current.y, 2))

			var fa := bend * d01 / (d01 + d12)
			var fb := bend * d12 / (d01 + d12)

			cp1 = Vector2(round(current.x - fa * (next.x - prev.x)), round(current.y - fa * (next.y - prev.y)))
			cp2 = Vector2(round(current.x + fb * (next.x - prev.x)), round(current.y + fb * (next.y - prev.y)))

			# Control points need to be relative to current point
			cp1 -= current
			cp2 -= current

		# TODO: tweak control points to be bungle a little less on the incurve
		curve.add_point(current, -cp2, -cp1)

	draw_polyline(curve.tessellate(), color, width, true)

func _path_updated(new_val: Array) -> void:
	path = new_val

	# Redraw
	update()

func move_along_path(obj: Node2D) -> void:
	remote_control.remote_path = obj.get_path()

	var time := clamp(path.size() * 0.2, 0.5, 2.5)

	# warning-ignore:return_value_discarded
	tween.interpolate_property(follow, "unit_offset", 0, 1, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	tween.start()
