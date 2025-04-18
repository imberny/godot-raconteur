## A schema describing the structure of the narrative world.
class_name RaconteurSchema extends Resource


@export var enums: Dictionary[StringName, Array] = {}
@export var properties: Dictionary[StringName, RaconteurProperty] = {}
@export var entities: Dictionary[StringName, Array] = {}
## Tags are used to mark entities with specific characteristics or states.
@export var tags: Array = []
## A dictionary of relationship names to a dictionary of entity pairs to their corresponding RaconteurRelationship objects.
## { relationship_name: { [entity_a, entity_b]: RaconteurRelationship } }
@export var relationship_definitions: Array[RaconteurRelationshipDefinition] = []
## A dictionary of instruction names to their corresponding RaconteurInstructionDefinition objects.
@export var instruction_definitions: Dictionary[StringName, RaconteurInstructionDefinition] = {}

var _entity_pairs_to_relationship_definitions: Dictionary[Array, Dictionary] = {}
var _relationship_name_to_entity_pairs: Dictionary[StringName, Array] = {}


## Checks if the schema contains an enum with the given name.
func enum_has(name: StringName) -> bool:
	return enums.has(name)


## Adds a new enum to the schema with the given name and values.
func enum_add(name: StringName, values: Array) -> void:
	enums[name] = values


## Returns a dictionary of enum names to their array of possible StringName values.
func enum_list() -> Dictionary:
	return enums


## Validates if the given value is a valid enum value.
func enum_validate(name: StringName, value: StringName) -> String:
	var enum_values: Array = enums.get(name, [])
	if enum_values.is_empty():
		return "Enum '%s' not found" % name
	if not enum_values.has(value):
		return "Invalid enum value '%s' for enum '%s'" % [value, name]
	return ""


## Adds a new property to the schema with the given name and type.
func property_add(name: StringName, type: RaconteurProperty.Type, enum_name := &"") -> String:
	if RaconteurProperty.Type.ENUM == type and not enums.has(enum_name):
		return "Enum '%s' not found" % enum_name
	properties[name] = RaconteurProperty.new(type, enum_name)
	return ""


## Returns a dictionary of property names to their types.
func property_list() -> Dictionary:
	return properties


## Returns a RaconteurProperty object for the given property name.
func property_get(property_name: StringName) -> RaconteurProperty:
	return properties.get(property_name, null)


## Validates if the given value is a valid property value.
func property_validate(property_name: StringName, value: Variant) -> String:
	var property: RaconteurProperty = properties.get(property_name, null)
	if not property:
		return "Property '%s' not found" % property_name

	return property.validate(self, value)


## Checks if the schema contains an entity with the given name.
func entity_has(name: StringName) -> bool:
	return entities.has(name)


## Adds a new entity type with the given name and properties.
func entity_add(name: StringName, entity_properties: Array) -> String:
	if &"line" == name:
		return "'line' is a reserved keyword and cannot be used as an entity type."
	entities[name] = entity_properties
	return ""


## Returns the properties of a specific entity type.
func entity_get(name: StringName) -> Array:
	return entities.get(name, [])


func tag_has(name: StringName) -> bool:
	return tags.has(name)


## Adds a tag to the schema.
func tag_add(name: StringName) -> void:
	tags.append(name)


## Adds a relationship between two entities with an optional qualifier property.
func relationship_definition_add(
	entity_a: StringName,
	relationship_name: StringName,
	entity_b: StringName,
	qualifier_enum := &"",
) -> void:
	relationship_definitions.append(RaconteurRelationshipDefinition.new(entity_a, relationship_name, entity_b, qualifier_enum))
	_try_rebuild_relationship_cache()


## Returns an array of relationship names between two entities.
func relationship_definitions_get_between(entity_a: StringName, entity_b: StringName) -> Array:
	_try_rebuild_relationship_cache()

	var definitions: Array = _entity_pairs_to_relationship_definitions.get([entity_a, entity_b], {}).values()
	return definitions.map(func(d): return d.relationship_name)


## Returns a specific RaconteurRelationship object between two entities.
func relationship_definition_get(entity_type_a: StringName, relationship_name: StringName, entity_type_b: StringName) -> RaconteurRelationshipDefinition:
	_try_rebuild_relationship_cache()

	var definitions := _entity_pairs_to_relationship_definitions[[entity_type_a, entity_type_b]]
	return definitions.get(relationship_name, null)


## Returns a list of errors in the described relationship.
func relationship_definition_validate(entity_type_a: StringName, relationship_name: StringName, entity_type_b: StringName, qualifier_value: StringName) -> Array:
	var errors := []
	var relationship: RaconteurRelationshipDefinition = relationship_definition_get(entity_type_a, relationship_name, entity_type_b)
	if not relationship:
		errors.append("Relationship '%s' between '%s' and '%s' not found" % [relationship_name, entity_type_a, entity_type_b])
		return errors
	if not relationship.qualifier_enum == &"" and not qualifier_value:
		errors.append("Qualifier value required for relationship '%s'" % relationship_name)
	var relationship_errors := relationship.validate(self, entity_type_a, entity_type_b, qualifier_value)
	errors.append_array(relationship_errors)
	return errors


## Adds a new instruction definition to the schema with the given name and arguments.
func instruction_definition_add(name: StringName, args: Array[StringName]) -> String:
	# TODO: add additional info on args, mainly: is entity, is line, is enum
	var arg_types: Array[RaconteurInstructionDefinition.ArgType] = []
	for arg in args:
		if &"line" == arg:
			arg_types.append(RaconteurInstructionDefinition.ArgType.LINE)
		elif entity_has(arg):
			arg_types.append(RaconteurInstructionDefinition.ArgType.ENTITY)
		elif enum_has(arg):
			arg_types.append(RaconteurInstructionDefinition.ArgType.ENUM)
		else:
			return "Invalid argument: %s." % arg
	instruction_definitions[name] = RaconteurInstructionDefinition.new(name, args, arg_types)
	return ""


## Sets a callback for the specified instruction.
func instruction_definition_set_callback(name: StringName, callback: Callable) -> String:
	var instruction = instruction_definitions.get(name, null)
	if not instruction:
		return "Instruction definition '%s' not found" % name
		

	if len(instruction.args) != callback.get_argument_count():
		return \
			"Argument count mismatch for instruction definition callback '%s': expected %d, got %d" \
			% [name, len(instruction.args), callback.get_argument_count()]

	instruction.callback = callback
	return ""


## Returns a specific RaconteurInstructionDefinition object.
func instruction_definition_get(name: StringName) -> RaconteurInstructionDefinition:
	return instruction_definitions.get(name, null)


func _try_rebuild_relationship_cache() -> void:
	if _relationship_name_to_entity_pairs.size() == relationship_definitions.size():
		return

	_entity_pairs_to_relationship_definitions.clear()
	_relationship_name_to_entity_pairs.clear()

	for definition in relationship_definitions:
		var entity_pair := [definition.entity_type_a, definition.entity_type_b]

		if not _entity_pairs_to_relationship_definitions.has(entity_pair):
			_entity_pairs_to_relationship_definitions[entity_pair] = {}
		_entity_pairs_to_relationship_definitions[entity_pair][definition.relationship_name] = definition

		if not _relationship_name_to_entity_pairs.has(definition.relationship_name):
			_relationship_name_to_entity_pairs[definition.relationship_name] = []
		_relationship_name_to_entity_pairs[definition.relationship_name].append(entity_pair)
