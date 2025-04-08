class_name RaconteurSchema extends Resource


var _enums: Dictionary[StringName, Array] = {}
var _properties: Dictionary[StringName, RaconteurProperty] = {}
var _entities: Dictionary[StringName, Array] = {}
var _tags: Array = []
var _relationships: Dictionary[StringName, Dictionary] = {}
var _entity_relationships_map: Dictionary[Array, Array] = {}
var _instructions: Dictionary[StringName, RaconteurInstruction] = {}
var _global_entities: Dictionary[StringName, StringName] = {}


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
func property_add(name: StringName, type: RaconteurProperty.Type, enum_name := &"") -> void:
    _properties[name] = RaconteurProperty.new(type, enum_name)


## Returns a dictionary of property names to their types.
func properties() -> Dictionary:
    return _properties


func property_get(property_name: StringName) -> RaconteurProperty:
    return _properties.get(property_name, null)


func property_validate(property_name: StringName, value: Variant) -> String:
    var property: RaconteurProperty = _properties.get(property_name, null)
    if not property:
        return "Property '%s' not found" % property_name

    return property.validate(self, value)


func entity_has(name: StringName) -> bool:
    return _entities.has(name)


## Adds a new entity type with the given name and properties.
func entity_add(name: StringName, entity_properties: Array) -> void:
    _entities[name] = entity_properties


## Returns a dictionary of entity names to their properties.
func entities() -> Dictionary:
    return _entities


## Returns the properties of a specific entity type.
func entity_get(name: StringName) -> Array:
    return _entities.get(name, [])


## Validates if the given properties match the expected properties for the entity type.
func entity_validate(name: StringName, properties: Dictionary) -> Array:
    var errors := []
    var entity_properties: Array = entity_get(name)
    if entity_properties.is_empty():
        errors.push_back("Entity '%s' not found" % name)
        return errors
    for property_name in entity_properties:
        if not properties.has(property_name):
            errors.push_back("Missing property '%s' for entity '%s'" % [property_name, name])
        var property_error := property_validate(property_name, properties[property_name])
        if property_error:
            errors.push_back(property_error)
    return errors


## Adds a tag to the schema.
## Tags are used to mark entities with specific characteristics or states.
func tag_add(name: StringName) -> void:
    _tags.push_back(name)


## Returns an array of all tags in the schema.
func tags() -> Array:
    return _tags


## Adds a relationship between two entities with an optional qualifier property.
func relationship_add(
    relationship_name: StringName,
    entity_a: StringName,
    entity_b: StringName,
    qualifier_property := &"",
) -> void:
    if not _relationships.has(relationship_name):
        _relationships[relationship_name] = {}
    var relationship := _relationships[relationship_name]
    relationship[[entity_a, entity_b]] = RaconteurRelationship.new(entity_a, entity_b, qualifier_property)
    if not _entity_relationships_map.has([entity_a, entity_b]):
        _entity_relationships_map[[entity_a, entity_b]] = []
    _entity_relationships_map[[entity_a, entity_b]].push_back(
        relationship_name
    )


## Returns a dictionary of relationship names to a dictionary of entity pairs to their corresponding RaconteurRelationship objects.
## { relationship_name: { [entity_a, entity_b]: RaconteurRelationship } }
func relationships() -> Dictionary:
    return _relationships


## Returns an array of relationship names between two entities.
func relationships_get_between(entity_a: StringName, entity_b: StringName) -> Array:
    return _entity_relationships_map.get([entity_a, entity_b], [])


## Returns a specific RaconteurRelationship object between two entities.
func relationship_get(relationship_name: StringName, entity_a: StringName, entity_b: StringName) -> RaconteurRelationship:
    var relationships: Dictionary = _relationships.get(relationship_name, {})
    if relationships.is_empty():
        return null
    
    return relationships.get([entity_a, entity_b], null)


## Adds a new instruction to the schema with the given name and arguments.
func instruction_add(name: StringName, args: Array) -> void:
    _instructions[name] = RaconteurInstruction.new(name, args)


## Sets a callback for the specified instruction.
func instruction_set_callback(name: StringName, callback: Callable) -> String:
    var instruction = _instructions.get(name, null)
    if not instruction:
        return "Instruction '%s' not found" % name
        

    if len(instruction.args) != callback.get_argument_count():
        return \
            "Argument count mismatch for instruction callback '%s': expected %d, got %d" \
            % [name, len(instruction.args), callback.get_argument_count()]

    instruction.callback = callback
    return ""


## Returns a dictionary of instruction names to their corresponding RaconteurInstruction objects.
func instructions() -> Dictionary:
    return _instructions


## Returns a specific RaconteurInstruction object.
func instruction_get(name: StringName) -> RaconteurInstruction:
    return _instructions.get(name, null)


## Adds a global entity to the schema with the given name and type.
func global_entity_add(name: StringName, entity_type: StringName) -> void:
    _global_entities[name] = entity_type


## Returns a dictionary of global entity names to their types.
func global_entities() -> Dictionary:
    return _global_entities
