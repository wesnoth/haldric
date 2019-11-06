extends Control

onready var minimap_camera := $MinimapViewportContainer/Viewport/Camera2D as Camera2D
onready var minimap_viewport_container := $MinimapViewportContainer
onready var viewport := $MinimapViewportContainer/Viewport as Viewport 
onready var area_of_view := $MinimapAreaOfView as Control

var map_pixel_size : Vector2

signal map_position_change_requested

func initialize(world_2d : World2D, map_pixel_size : Vector2, main_camera : Camera2D) -> void:
	viewport.world_2d = world_2d
	# todo: - will need update for resizing probably
	minimap_camera.zoom = map_pixel_size / rect_size
	minimap_camera.position = map_pixel_size / 2
	
	self.map_pixel_size = map_pixel_size
	# todo: - will need update for resizing probably
	
	main_camera.connect("position_changed", self, "_on_map_camera_position_changed")
	main_camera.connect("zoom_changed", self, "_on_map_camera_zoom_changed")
	
	area_of_view.rect_size = main_camera.zoom * rect_size
	area_of_view.rect_pivot_offset = rect_size / 2
	_on_map_camera_position_changed(main_camera.position)
	
	minimap_viewport_container.connect("minimap_area_of_view_moved", self, "_on_minimap_area_of_view_moved")


func _on_minimap_area_of_view_moved(move_target: Vector2):
	emit_signal("map_position_change_requested", move_target * minimap_camera.zoom)

#this is center of camera view
func _on_map_camera_position_changed(new_position : Vector2) -> void:
	area_of_view.rect_position = (new_position / minimap_camera.zoom) - (area_of_view.rect_size / 2)


func _on_map_camera_zoom_changed(new_zoom : Vector2) -> void:
	area_of_view.rect_scale = new_zoom 
