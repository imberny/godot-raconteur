## A schema describing the structure of the narrative world.
class_name RaconteurSchema extends Resource


var _enums: Dictionary[StringName, Array] = {}
var _properties: Dictionary[StringName, RaconteurProperty] = {}
var _entities: Dictionary[StringName, Array] = {}
var _tags: Array = []
var _relationship_definitions: Dictionary[StringName, Dictionary] = {}
var _entity_relationships_map: Dictionary[Array, Array] = {}
var _instruction_definitions: Dictionary[StringName, RaconteurInstructionDefinition] = {}
var _global_entities: Dictionary[StringName, StringName] = {}


## Checks if the schema contains an enum with the given name.
func enum_has(name: StringName) -> bool:
	return _enums.has(name)


## Adds a new enum to the schema with the given name and values.
func enum_add(name: StringName, values: Array) -> void:
	_enums[name] = values


## Returns a dictionary of enum names to their array of possible StringName values.
func enums() -> Dictionary:
	return _enums


## Validates if the given value is a valid enum value.
func enum_validate(name: StringName, value: StringName) -> String:
	var enum_values: Array = _enums.get(name, [])
	if enum_values.is_empty():
		return "Enum '%s' not found" % name
	if not enum_values.has(value):
		return "Invalid enum value '%s' for enum '%s'" % [value, name]
	return ""


## Adds a new property to the schema with the given name and type.
func property_add(name: StringName, type: RaconteurProperty.Type, enum_name := &"") -> String:
	if RaconteurProperty.Type.ENUM == type and not _enums.has(enum_name):
		return "Enum '%s' not found" % enum_name
	_properties[name] = RaconteurProperty.new(type, enum_name)
	return ""


## Returns a dictionary of property names to their types.
func properties() -> Dictionary:
	return _properties


## Returns a RaconteurProperty object for the given property name.
func property_get(property_name: StringName) -> RaconteurProperty:
	return _properties.get(property_name, null)


## Validates if the given value is a valid property value.
func property_validate(property_name: StringName, value: Variant) -> String:
	var property: RaconteurProperty = _properties.get(property_name, null)
	if not property:
		return "Property '%s' not found" % property_name

	return property.validate(self, value)


## Checks if the schema contains an entity with the given name.
func entity_has(name: StringName) -> bool:
	return _entities.has(name)


## Adds a new entity type with the given name and properties.
func entity_add(name: StringName, entity_properties: Array) -> String:
	if &"line" == name:
		return "'line' is a reserved keyword and cannot be used as an entity type."
	_entities[name] = entity_properties
	return ""


## Returns a dictionary of entity names to their properties.
func entities() -> Dictionary:
	return _entities


## Returns the properties of a specific entity type.
func entity_get(name: StringName) -> Array:
	return _entities.get(name, [])


func tag_has(name: StringName) -> bool:
	return _tags.has(name)


## Adds a tag to the schema.
## Tags are used to mark entities with specific characteristics or states.
func tag_add(name: StringName) -> void:
	_tags.append(name)


## Returns an array of all tags in the schema.
func tags() -> Array:
	return _tags


## Adds a relationship between two entities with an optional qualifier property.
func relationship_definition_add(
	entity_a: StringName,
	relationship_name: StringName,
	entity_b: StringName,
	qualifier_enum := &"",
) -> void:
	if not _relationship_definitions.has(relationship_name):
		_relationship_definitions[relationship_name] = {}
	var relationship := _relationship_definitions[relationship_name]
	relationship[[entity_a, entity_b]] = RaconteurRelationshipDefinition.new(entity_a, relationship_name, entity_b, qualifier_enum)
	if not _entity_relationships_map.has([entity_a, entity_b]):
		_entity_relationships_map[[entity_a, entity_b]] = []
	_entity_relationships_map[[entity_a, entity_b]].append(
		relationship_name
	)


## Returns a dictionary of relationship names to a dictionary of entity pairs to their corresponding RaconteurRelationship objects.
## { relationship_name: { [entity_a, entity_b]: RaconteurRelationship } }
func relationship_definitions() -> Dictionary:
	return _relationship_definitions


## Returns an array of relationship names between two entities.
func relationship_definitions_get_between(entity_a: StringName, entity_b: StringName) -> Array:
	return _entity_relationships_map.get([entity_a, entity_b], [])


## Returns a specific RaconteurRelationship object between two entities.
func relationship_definition_get(entity_a: StringName, relationship_name: StringName, entity_b: StringName) -> RaconteurRelationshipDefinition:
	var relationships: Dictionary = _relationship_definitions.get(relationship_name, {})
	if relationships.is_empty():
		return null
	
	return relationships.get([entity_a, entity_b], null)


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
	_instruction_definitions[name] = RaconteurInstructionDefinition.new(name, args, arg_types)
	return ""


## Sets a callback for the specified instruction.
func instruction_definition_set_callback(name: StringName, callback: Callable) -> String:
	var instruction = _instruction_definitions.get(name, null)
	if not instruction:
		return "Instruction definition '%s' not found" % name
		

	if len(instruction.args) != callback.get_argument_count():
		return \
			"Argument count mismatch for instruction definition callback '%s': expected %d, got %d" \
			% [name, len(instruction.args), callback.get_argument_count()]

	instruction.callback = callback
	return ""


## Returns a dictionary of instruction names to their corresponding RaconteurInstructionDefinition objects.
func instruction_definitions() -> Dictionary:
	return _instruction_definitions


## Returns a specific RaconteurInstructionDefinition object.
func instruction_definition_get(name: StringName) -> RaconteurInstructionDefinition:
	return _instruction_definitions.get(name, null)
