extends Path2D
class_name UnitPathDisplay

export var bend := 0.3

var path := [] setget _path_updated
var callback = null

onready var follow := $Follow as PathFollow2D
onready var tween := $Tween as Tween
onready var remote_control := $Follow/RemoteControl as RemoteTransform2D

func _update_interp() -> void:
	curve.clear_points()

	if path.size() < 2:
		return

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


func _path_updated(new_val: Array) -> void:
	path = new_val
	_update_interp()
	# Redraw
	update()

func _draw():
	if callback:
		callback.invoke(self)
