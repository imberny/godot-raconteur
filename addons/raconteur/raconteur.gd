## This class allows querying a list of possible scenario_definitions for the given world.
class_name Raconteur

var schema: RaconteurSchema
var scenario_definitions: Array[RaconteurScenarioDefinition] = []


func _init(schema_: RaconteurSchema) -> void:
	schema = schema_


func scenario_definition_add(scenario: RaconteurScenarioDefinition) -> void:
	scenario_definitions.append(scenario)


func query(world: RaconteurWorld) -> Array[RaconteurScenario]:
	var scenarios: Array[RaconteurScenario] = []

	for scenario_def in scenario_definitions:
		var suitable_scenarios := _try_match_scenario(world, scenario_def)
		scenarios.append_array(suitable_scenarios)

	return scenarios


func _try_match_scenario(
	world: RaconteurWorld, definition: RaconteurScenarioDefinition
) -> Array[RaconteurScenario]:
	if world.scenario_is_excluded(definition.title):
		return []

	var scenarios: Array[RaconteurScenario] = []

	# gather candidates for each alias based on required entity type
	var first_pass_candidates: Dictionary[StringName, Array] = {}
	var alias_list := definition.aliases.keys()
	for i in len(alias_list):
		var alias: StringName = alias_list[i]
		var alias_entity_type := definition.aliases[alias]
		var entities := world.entities.duplicate()
		var candidates: Array[StringName] = []
		for entity in entities.values():
			if entity.type == alias_entity_type:
				candidates.append(entity.key)
		first_pass_candidates[alias] = candidates

	# Generate all permutations
	var permutations := _generate_permutations_recursive(first_pass_candidates.values().duplicate())

	for permutation in permutations:
		var alias_bindings: Dictionary[StringName, StringName] = {}
		for i in len(alias_list):
			var alias: StringName = alias_list[i]
			alias_bindings[alias] = permutation[i]
		if _is_permutation_valid(world, definition, alias_bindings):
			scenarios.append(RaconteurScenario.new(schema, definition, alias_bindings))
	return scenarios


func _generate_permutations_recursive(arr: Array[Array]) -> Array[Array]:
	if arr.is_empty():
		return [[]]

	var permutations: Array[Array] = []

	var sub_array := arr.pop_back()
	for item in sub_array:
		var sub_permutations := _generate_permutations_recursive(arr.duplicate())
		for sub_perm in sub_permutations:
			if not sub_perm.has(item):
				sub_perm.append(item)
				permutations.append(sub_perm)
	return permutations


func _is_permutation_valid(
	world: RaconteurWorld,
	definition: RaconteurScenarioDefinition,
	alias_bindings: Dictionary,
) -> bool:
	for constraint in definition.constraints:
		if not constraint.is_satisfied(world, alias_bindings):
			return false
	return true
