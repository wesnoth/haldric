extends Resource
class_name RTime

export var name := ""

export var tint_red := 0
export var tint_green := 0
export var tint_blue := 0

export(Array, String) var advantage := []
export(Array, String) var disadvantage := []

export(int, 0, 100) var bonus := 0
export(int, 0, 100) var malus := 0