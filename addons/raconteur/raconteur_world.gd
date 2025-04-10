## A simplified narrative world representing the state of the game's world.
class_name RaconteurWorld


## The schema describing the structure of the narrative world.
var _schema: RaconteurSchema
## A map of entity keys to a raconteur entity
var _entities: Dictionary[StringName, RaconteurEntity] = {}
## A map of entity types to a list of entity keys
var _type_to_entity_keys: Dictionary[StringName, Array] = {}
var _global_entities: Dictionary[StringName, RaconteurEntity] = {}
var _relationships: Dictionary[Array, Dictionary] = {}


func _init(schema: RaconteurSchema) -> void:
	_schema = schema


func entity_get(key: StringName) -> RaconteurEntity:
	return _entities.get(key, null)


## Adds an entity to the world with the given type, key, and properties.
func entity_add(entity_type: StringName, key: StringName, properties: Dictionary) -> Array:
	var errors := []
	
	var entity_errors := RaconteurEntity.validate(_schema, key, entity_type, properties)
	errors.append_array(entity_errors)
	if not errors.is_empty():
		return errors
	
	_entities[key] = RaconteurEntity.new(key, entity_type, properties)
	if not _type_to_entity_keys.has(entity_type):
		_type_to_entity_keys[entity_type] = []
	_type_to_entity_keys[entity_type].append(key)
		
	return []


func entity_tag(entity_key: StringName, tag: StringName) -> String:
	if not _schema.tag_has(tag):
		return "Tag '%s' not found" % tag

	if not _entities.has(entity_key):
		return "Entity '%s' not found" % entity_key

	var entity := _entities[entity_key]
	entity.tag_add(tag)
	return ""


func entity_untag(entity_key: StringName, tag: StringName) -> String:
	if not _schema.tag_has(tag):
		return "Tag '%s' not found" % tag

	if not _entities.has(entity_key):
		return "Entity '%s' not found" % entity_key

	var entity := _entities[entity_key]
	entity.tag_remove(tag)
	return ""


## Adds a relationship to the world between two entities with the given name and optional qualifier value.
func relationship_add(
	entity_key_a: StringName,
	relationship_name: StringName,
	entity_key_b: StringName,
	qualifier_value := &"",
) -> Array:
	var entity_type_a := _entities[entity_key_a].type()
	var entity_type_b := _entities[entity_key_b].type()
	var errors := _schema.relationship_definition_validate(entity_type_a, relationship_name, entity_type_b, qualifier_value)
	if not errors.is_empty():
		return errors

	if not _relationships.has([entity_key_a, entity_key_b]):
		_relationships[[entity_key_a, entity_key_b]] = {}
	_relationships[[entity_key_a, entity_key_b]][relationship_name] = RaconteurRelationship.new(entity_key_a, relationship_name, entity_key_b, qualifier_value)
	return []


func relationship_has(entity_key_a: StringName, relationship_name: StringName, entity_key_b: StringName, qualifier_value := &"") -> bool:
	var ok := _relationships.has([entity_key_a, entity_key_b])
	ok = ok and _relationships[[entity_key_a, entity_key_b]].has(relationship_name)
	if ok and not qualifier_value.is_empty():
		var relationship: RaconteurRelationship = _relationships[[entity_key_a, entity_key_b]][relationship_name]
		ok = qualifier_value == relationship.qualifier_value
	return ok


func relationship_get(entity_key_a: StringName, relationship_name: StringName, entity_key_b: StringName) -> RaconteurRelationship:
	if not relationship_has(entity_key_a, relationship_name, entity_key_b):
		return null
	
	return _relationships[[entity_key_a, entity_key_b]].get(relationship_name, null)


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


## Returns the global entity by key or null if it doesn't exist.
func global_entity_get(key: StringName) -> RaconteurEntity:
	return _global_entities.get(key, null)
