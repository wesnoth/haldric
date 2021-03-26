extends PanelContainer

class_name ReplicaDialog

signal close_replica

onready var character_name = $VBoxContainer/CharacterName
onready var replica = $VBoxContainer/ReplicaText

func _unhandled_input(event):
	if event is InputEventMouseButton:
		emit_signal("close_replica")


func update_info(data: Replica) -> void:
	character_name.text = data.character_name
	replica.text = data.replica


func clear() -> void:
	character_name.text = ""
	replica.text = ""
