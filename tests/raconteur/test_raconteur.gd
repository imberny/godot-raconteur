extends GutTest

const COMMON: GDScript = preload("res://tests/raconteur/common.gd")


func test_raconteur():
	var schema: RaconteurSchema = COMMON.schema()
	var world: RaconteurWorld = COMMON.alice_and_bob_world(schema)

	var raconteur := Raconteur.new(schema)
	for scenario in COMMON.scenario_definitions():
		raconteur.scenario_definition_add(scenario)

	var scenarios := raconteur.query(world)
	assert_eq(len(scenarios), 1)
	assert_eq(len(scenarios[0].alias_bindings), 2)


func test_raconteur_exclusions():
	var schema: RaconteurSchema = COMMON.schema()
	var world: RaconteurWorld = COMMON.alice_and_bob_world(schema)
	world.scenario_exclude(&"Message from wealthy woman")

	var raconteur := Raconteur.new(schema)
	for scenario in COMMON.scenario_definitions():
		raconteur.scenario_definition_add(scenario)

	var scenarios := raconteur.query(world)
	assert_eq(len(scenarios), 0)


func test_permutations_recursive():
	var arr: Array[Array] = [[1, 2, 3], [4], [5, 6, 7]]
	var expected := [
		[1, 4, 5],
		[2, 4, 5],
		[3, 4, 5],
		[1, 4, 6],
		[2, 4, 6],
		[3, 4, 6],
		[1, 4, 7],
		[2, 4, 7],
		[3, 4, 7],
	]
	var raconteur := Raconteur.new(RaconteurSchema.new())
	var result := raconteur._generate_permutations_recursive(arr)

	assert_eq(result, expected)
