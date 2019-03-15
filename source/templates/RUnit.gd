class_name RUnit extends Resource

export(Texture) var base_image = null

export(String) var name = ""
export(String) var ID = ""
export(String) var race = ""
export(String) var alignment = ""

export(int) var level = 1
export(int) var cost = 1
export(int) var health = 1
export(int) var moves = 1
export(int) var experience = 1

export(String) var advances_to = ""

export(Array, Resource) var attacks = null

export(Resource) var defense = null
export(Resource) var movement = null
export(Resource) var resistance = null