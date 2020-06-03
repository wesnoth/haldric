extends Resource
class_name TerrainData

export var layer := 0

export var code := ""
export var name := ""

export var recruit_onto := false
export var recruit_from := false

export var gives_income := false

export var heals := false

export(String, "flat", "forest", "hills", "mountains", "water", "village", "castle", "special") var type := "flat"

export var graphic : Resource = null
