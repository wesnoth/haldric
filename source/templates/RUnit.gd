extends Resource
class_name RUnit

export var base_image: Texture = null

export var name := ""
export var ID := ""
export var race := ""
export var alignment := ""

export var level := 1
export var cost := 1
export var health := 1
export var moves := 1
export var experience := 1

export var advances_to := ""

export(Array, Resource) var attacks = null

export var defense: Resource = null
export var movement: Resource = null
export var resistance: Resource = null
