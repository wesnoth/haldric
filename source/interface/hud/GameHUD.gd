extends CanvasLayer

signal turn_end_pressed
signal unit_advancement_selected(unit, unit_id)
signal attack_selected(attack, target)
signal unit_recruitment_requested
signal unit_recruitment_menu_requested

onready var advancement_popup := $AdvancementPopup as AdvancementPopup
onready var attack_popup := $AttackPopup as AttackPopup
onready var recruitment_popup := $RecruitmentPopup as Popup
onready var recruitment_button := $RecruitmentButton as Button

onready var unit_panel := $UnitPanel as Control
onready var side_panel := $SidePanel as Control
onready var tod_widget := $ToDWidget as Control

onready var pause_menu := $PauseMenu as Control

func _ready() -> void:
	advancement_popup.connect("advancement_selected", self, "_on_advancement_selected")
	attack_popup.connect("attack_selected", self, "_on_attack_selected")
	recruitment_button.connect("pressed", self, "_on_recruitment_popup_requested")
	recruitment_popup.connect("unit_recruitment_requested", self, "_on_unit_recruitment_requested")

func show_advancement_popup(unit: Unit) -> void:
	advancement_popup.popup_unit(unit)

func show_attack_popup(unit: Unit, target: Unit) -> void:
	attack_popup.popup_attack(unit, target)

func update_time_info(time: Time) -> void:
	if not time:
		return
	tod_widget.update_time(time)

func update_unit_info(unit : Unit) -> void:
	unit_panel.update_unit(unit)

func set_recruitment_allowed(is_allowed : bool) -> void:
	recruitment_button.visible = is_allowed

func update_side_info(scenario : Scenario, side : Side) -> void:
	side_panel.update_side(scenario, side)

func clear_unit_info() -> void:
	unit_panel.clear_unit()

func _on_advancement_selected(unit: Unit, unit_id: String) -> void:
	emit_signal("unit_advancement_selected", unit, unit_id)

func _on_attack_selected(combatChoices: Dictionary, target: Unit) -> void:
	emit_signal("attack_selected", combatChoices, target)

func _on_Back_pressed() -> void:
	Scene.change("TitleScreen")

func _on_TurnEndPanel_turn_end_pressed() -> void:
	emit_signal("turn_end_pressed")

func _on_recruitment_popup_requested() -> void:
	emit_signal("unit_recruitment_menu_requested")

func open_recruitment_menu(unit_types : Array) -> void:
	recruitment_popup.show_popup(unit_types)

func _on_unit_recruitment_requested(unit_type : UnitType) -> void:
	emit_signal("unit_recruitment_requested", unit_type)
