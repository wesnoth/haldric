extends Node

const Unit = preload("res://source/unit/Unit.tscn")
const Scenario = preload("res://source/scenario/old/Scenario.tscn")

func unit() -> Unit:
	return Unit.instance() as Unit

func scenario() -> Scenario:
	return Scenario.instance() as Scenario