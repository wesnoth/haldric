extends PopupMenu

func add_recruits(recruit_list):
	clear()
	var index = 0
	for recruit in recruit_list:
		var unit_entry = Registry.units[recruit]
		add_icon_item(load(unit_entry.image), str("(", unit_entry.cost, ") ", unit_entry.id), index)
		set_item_metadata(index, unit_entry)
		index += 1
