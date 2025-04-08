class_name RaconteurWorld


var _schema: RaconteurSchema
## A map of entity keys to their properties
var _entities: Dictionary[StringName, Dictionary] = {}
## A map of entity keys to their type
var _entity_types: Dictionary[StringName, StringName] = {}
## A map of entity types to a list of entity keys
var _type_to_entity_keys: Dictionary[StringName, Array] = {}


func _init(schema: RaconteurSchema) -> void:
	_schema = schema


func entity_add(entity_type: StringName, key: StringName, properties: Dictionary) -> Array:
	var errors := _schema.entity_validate(entity_type, properties)
	if not errors.is_empty():
		return errors
	
	_entities[key] = properties
	_entity_types[key] = entity_type
	if not _type_to_entity_keys.has(entity_type):
		_type_to_entity_keys[entity_type] = []
	_type_to_entity_keys[entity_type].append(key)
		
	return []


func relationship_add(
	entity_key_a: StringName,
	entity_key_b: StringName,
	relationship_name: StringName,
	qualifier_value: StringName = "",
) -> Array:
	var entity_type_a := _entity_types[entity_key_a]
	var entity_type_b := _entity_types[entity_key_b]
	var errors := _schema.relationship_validate(entity_type_a, entity_type_b, relationship_name, qualifier_value)
	if not errors.is_empty():
		return errors

	return []
