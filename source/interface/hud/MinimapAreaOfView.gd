extends Control

func _draw ():
	draw_line(rect_position, rect_position + Vector2(rect_size.x , 0), Color(1, 1, 1))
	draw_line(rect_position, rect_position + Vector2(0 , rect_size.y), Color(1, 1, 1))
	draw_line(rect_position + Vector2(0 , rect_size.y), rect_position + rect_size, Color(1, 1, 1))
	draw_line(rect_position + Vector2(rect_size.x , 0), rect_position + rect_size, Color(1, 1, 1))
