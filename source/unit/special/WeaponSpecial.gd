extends Node
class_name WeaponSpecial

enum Target { SELF, OPPONENT, OFFENDER, DEFENDER, BOTH }
enum Activation { OFFENSE, DEFENSE, BOTH }

export var alias := ""
export(String, MULTILINE) var description := ""

export(Target) var apply_to = Target.SELF
export(Activation) var active_on := Activation.BOTH


func execute(_self: CombatContext, opponent: CombatContext, offender: CombatContext, defender: CombatContext) -> void:

	match apply_to:

		Target.SELF:

			match active_on:

				Activation.BOTH:
					_execute(_self)

				Activation.OFFENSE:
					if _self == offender:
						_execute(_self)

				Activation.DEFENSE:
					if _self == defender:
						_execute(_self)

		Target.OPPONENT:

			match active_on:

				Activation.BOTH:
					_execute(opponent)

				Activation.OFFENSE:
					if opponent == offender:
						_execute(opponent)

				Activation.DEFENSE:
					if opponent == defender:
						_execute(opponent)

		Target.OFFENDER:

			match active_on:

				Activation.BOTH:
					_execute(offender)
				Activation.OFFENSE:
					_execute(offender)

		Target.DEFENDER:

				match active_on:

					Activation.BOTH:
						_execute(defender)

					Activation.DEFENSE:
						_execute(defender)

		Target.BOTH:

			match active_on:

				Activation.BOTH:
					_execute(_self)
					_execute(opponent)

				Activation.OFFENSE:
					if _self == offender:
						_execute(_self)
						_execute(opponent)

				Activation.DEFENSE:
					if opponent == defender:
						_execute(_self)
						_execute(opponent)


# virtual
func _execute(target: CombatContext) -> void:
	pass
