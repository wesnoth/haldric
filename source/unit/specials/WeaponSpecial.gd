extends Node
class_name WeaponSpecial

enum TARGET { SELF, OPPONENT, OFFENDER, DEFENDER, BOTH }
enum ACTIVATION { OFFENSE, DEFENSE, BOTH }

export var alias := ""
export(String, MULTILINE) var description := ""

export(TARGET) var apply_to = TARGET.SELF
export(ACTIVATION) var active_on := ACTIVATION.BOTH


func execute(_self: CombatContext, opponent: CombatContext, offender: CombatContext, defender: CombatContext) -> void:

	match apply_to:

		TARGET.SELF:

			match active_on:

				ACTIVATION.BOTH:
					_execute(_self)

				ACTIVATION.OFFENSE:
					if _self == offender:
						_execute(_self)

				ACTIVATION.DEFENSE:
					if _self == defender:
						_execute(_self)

		TARGET.OPPONENT:

			match active_on:

				ACTIVATION.BOTH:
					_execute(opponent)

				ACTIVATION.OFFENSE:
					if opponent == offender:
						_execute(opponent)

				ACTIVATION.DEFENSE:
					if opponent == defender:
						_execute(opponent)

		TARGET.OFFENDER:

			match active_on:

				ACTIVATION.BOTH:
					_execute(offender)
				ACTIVATION.OFFENSE:
					_execute(offender)

		TARGET.DEFENDER:

				match active_on:

					ACTIVATION.BOTH:
						_execute(defender)

					ACTIVATION.DEFENSE:
						_execute(defender)

		TARGET.BOTH:

			match active_on:

				ACTIVATION.BOTH:
					_execute(_self)
					_execute(opponent)

				ACTIVATION.OFFENSE:
					if _self == offender:
						_execute(_self)
						_execute(opponent)

				ACTIVATION.DEFENSE:
					if opponent == defender:
						_execute(_self)
						_execute(opponent)


# virtual
func _execute(target: CombatContext) -> void:
	pass
