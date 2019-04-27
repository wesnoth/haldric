extends Node

func unit() -> Unit:
	return Wesnoth.Unit.instance() as Unit

func scenario() -> Scenario:
	return Wesnoth.Scenario.instance() as Scenario
