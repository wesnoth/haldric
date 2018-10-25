extends PopupMenu

func add_attacks(attacks):
	clear()

	var index = 0
	for attack in attacks:
		add_icon_item(load(attack.icon), str(attack.name, ": ", attack.damage, " x ", attack.strikes, " (", attack.type, ")"), index)
		index += 1