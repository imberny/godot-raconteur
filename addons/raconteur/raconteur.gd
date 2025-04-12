## This class allows querying a list of possible beat_definitions for the given world.
class_name Raconteur


var schema: RaconteurSchema
var beat_definitions: Array[RaconteurBeatDefinition] = []


func _init(schema_: RaconteurSchema) -> void:
	schema = schema_


func beat_definition_add(beat: RaconteurBeatDefinition) -> void:
	beat_definitions.append(beat)


func query(world: RaconteurWorld) -> Array[RaconteurBeat]:
	var beats: Array[RaconteurBeat] = []

	for beat_def in beat_definitions:
		var suitable_beats := _try_match_beat(world, beat_def)
		beats.append_array(suitable_beats)

	return beats


func _try_match_beat(world: RaconteurWorld, definition: RaconteurBeatDefinition) -> Array[RaconteurBeat]:
	var beats: Array[RaconteurBeat] = []
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
			beats.append(RaconteurBeat.new(schema, definition, alias_bindings))
	return beats


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
	definition: RaconteurBeatDefinition,
	alias_bindings: Dictionary,
) -> bool:
	for constraint in definition.constraints:
		if not constraint.is_satisfied(world, alias_bindings):
			return false
	return true
