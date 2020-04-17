extends PanelContainer
class_name CombatPlate

onready var combat = {'offense': {}, 'defense': {}} # A dictionary which holds a map to our various nodes for each access

func _ready() -> void:
	for type in ['offense', 'defense']: # We prepare out node map since they share a common naming scheme between offense/defense
		combat[type]['icon'] = $CombatHBox.get_node(type.capitalize() + 'Icon')
		for label in ['name', 'damage', 'details', 'specials']:
			combat[type][label] = $CombatHBox.get_node(type.capitalize() + 'Details/' + label.capitalize()) as Label

func update_attack_label(unit: Unit, attack : Attack, type : String) -> void:
	combat[type]['name'].text = attack.name
	print("TYPE: ", type, " DAMAGE: ", unit.get_attack_damage(attack))
	combat[type]['damage'].text = "%d x %d" % [unit.get_attack_damage(attack), attack.strikes]
	combat[type]['details'].text = attack.type
	combat[type]['icon'].texture = attack.icon

func update_attack_type(attack: Attack):
	$CombatHBox/CombatType.text = "--" + attack.reach + "--"

func clear() -> void:
	for type in ['offense', 'defense']:
		combat[type]['name'].text = ""
		combat[type]['damage'].text = ""
		combat[type]['details'].text = ""
		combat[type]['icon'].texture = null
