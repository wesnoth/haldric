extends PopupMenu

func add_recruits(recruit_list):
	clear()
	var index = 0
	for recruit in recruit_list:
		var unit = UnitRegistry.registry[recruit]
		add_icon_item(load(unit.image), str(unit.id))
		index += 1
