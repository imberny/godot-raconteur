## A simplified narrative world representing the state of the game's world.
class_name RaconteurWorld


## The schema describing the structure of the narrative world.
var _schema: RaconteurSchema
## A map of entity keys to their properties
var _entities: Dictionary[StringName, Dictionary] = {}
## A map of entity keys to their type
var _entity_types: Dictionary[StringName, StringName] = {}
## A map of entity types to a list of entity keys
var _type_to_entity_keys: Dictionary[StringName, Array] = {}
var _global_entities: Dictionary[StringName, RaconteurEntity] = {}


func _init(schema: RaconteurSchema) -> void:
	_schema = schema


## Adds an entity to the world with the given type, key, and properties.
func entity_add(entity_type: StringName, key: StringName, properties: Dictionary) -> Array:
	var errors := []
	
	var entity_errors := RaconteurEntity.validate(_schema, key, entity_type, properties)
	errors.append_array(entity_errors)
	if not errors.is_empty():
		return errors
	
	_entities[key] = properties
	_entity_types[key] = entity_type
	if not _type_to_entity_keys.has(entity_type):
		_type_to_entity_keys[entity_type] = []
	_type_to_entity_keys[entity_type].append(key)
		
	return []


## Adds a relationship to the world between two entities with the given name and optional qualifier value.
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


## Adds a global entity to the world with the given name and type.
## A global entity is one that is always present in the narration. Its key should be all caps.
func global_entity_add(entity_type: StringName, key: StringName, properties: Dictionary) -> Array:
	var errors := RaconteurEntity.validate(_schema, key, entity_type, properties)
	if not errors.is_empty():
		return errors
	_global_entities[key] = RaconteurEntity.new(key, entity_type, properties)
	return []


## Returns a dictionary of global entity names to their types.
func global_entities() -> Dictionary:
	return _global_entities


func global_entity_get(key: StringName) -> RaconteurEntity:
	return _global_entities.get(key, null)
