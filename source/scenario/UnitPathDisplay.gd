extends Path2D

const BEND = 0.3
const COLOR = Color(255, 0, 0, 0.5)

var path := [] setget path_updated

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

			var fa := BEND * d01 / (d01 + d12)
			var fb := BEND * d12 / (d01 + d12)

			cp1 = Vector2(round(current.x - fa * (next.x - prev.x)), round(current.y - fa * (next.y - prev.y)))
			cp2 = Vector2(round(current.x + fb * (next.x - prev.x)), round(current.y + fb * (next.y - prev.y)))

			# Control points need to be relative to current point
			cp1 -= current
			cp2 -= current

		# TODO: tweak control points to be bungle a little less on the incurve
		curve.add_point(current, -cp2, -cp1)

	draw_polyline(curve.tessellate(), COLOR, 20, true)

func path_updated(new_val: Array) -> void:
	path = new_val

	# Redraw
	update()
