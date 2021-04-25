extends Resource
class_name ScenarioData

enum ScenarioType {SCENARIO, CAMPAIGN}

export var id := ""
export var alias := ""
export var scene : PackedScene = null
export var map : Resource = null

export var show = true

export (ScenarioType) var type := ScenarioType.SCENARIO;
