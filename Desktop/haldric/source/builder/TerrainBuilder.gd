class_name TerrainBuilder

var terrain := TerrainData.new()


func new_terrain() -> TerrainBuilder:
	terrain = TerrainData.new()
	return self


func with_name(name: String) -> TerrainBuilder:
	terrain.name = name
	return self


func with_code(code: String) -> TerrainBuilder:
	terrain.code = code
	return self


func with_type(type: Array) -> TerrainBuilder:
	terrain.type = type
	return self


func with_layer(layer: int) -> TerrainBuilder:
	terrain.layer = layer
	return self


func with_heals(heals := false) -> TerrainBuilder:
	terrain.heals = heals
	return self


func with_recruit_from(recruit_from := false) -> TerrainBuilder:
	terrain.recruit_from = recruit_from
	return self


func with_rectuit_onto(recruit_onto := false) -> TerrainBuilder:
	terrain.recruit_onto = recruit_onto
	return self


func with_gives_income(gives_income := false) -> TerrainBuilder:
	terrain.gives_income = gives_income
	return self


func with_graphic(terrain_graphic: TerrainGraphicData) -> TerrainBuilder:
	terrain.graphic = terrain_graphic
	return self


func build() -> TerrainData:
	return terrain
