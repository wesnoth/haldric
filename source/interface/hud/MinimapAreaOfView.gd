extends Control

func _draw ():
	var t = get_parent().viewport.canvas_transform
	# for whatever reason origin transform of viewport is incorrect at the start
	t[2] = Vector2(0,0)
	var translated_pos = t.xform(rect_position)
	draw_line(translated_pos, translated_pos + Vector2(rect_size.x , 0), Color(1, 1, 1))
	draw_line(translated_pos, translated_pos + Vector2(0 , rect_size.y), Color(1, 1, 1))
	draw_line(translated_pos + Vector2(0 , rect_size.y), translated_pos + rect_size, Color(1, 1, 1))
	draw_line(translated_pos + Vector2(rect_size.x , 0), translated_pos + rect_size, Color(1, 1, 1))

