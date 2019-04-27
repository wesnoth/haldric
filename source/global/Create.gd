extends Node

func unit() -> Unit:
	return Global.Unit.instance() as Unit

func scenario() -> Scenario:
	return Global.Scenario.instance() as Scenario
