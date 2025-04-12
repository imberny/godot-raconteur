## A simplified narrative world representing the state of the game's world.
class_name RaconteurWorld


## The schema describing the structure of the narrative world.
var schema: RaconteurSchema
## A map of entity keys to a raconteur entity
var entities: Dictionary[StringName, RaconteurEntity] = {}
## A map of entity types to a list of entity keys
var type_to_entity_keys: Dictionary[StringName, Array] = {}
var global_entities: Dictionary[StringName, RaconteurEntity] = {}
var relationships: Dictionary[Array, Dictionary] = {}


func _init(schema_: RaconteurSchema) -> void:
	schema = schema_


func entity_get(key: StringName) -> RaconteurEntity:
	return entities.get(key, null)


## Adds an entity to the world with the given type, key, and properties.
func entity_add(entity_type: StringName, key: StringName, properties: Dictionary) -> Array:
	var errors := []
	
	var entity_errors := RaconteurEntity.validate(schema, key, entity_type, properties)
	errors.append_array(entity_errors)
	if not errors.is_empty():
		return errors
	
	entities[key] = RaconteurEntity.new(key, entity_type, properties)
	if not type_to_entity_keys.has(entity_type):
		type_to_entity_keys[entity_type] = []
	type_to_entity_keys[entity_type].append(key)
		
	return []


func entity_tag(entity_key: StringName, tag: StringName) -> String:
	if not schema.tag_has(tag):
		return "Tag '%s' not found" % tag

	if not entities.has(entity_key):
		return "Entity '%s' not found" % entity_key

	var entity := entities[entity_key]
	entity.tag_add(tag)
	return ""


func entity_untag(entity_key: StringName, tag: StringName) -> String:
	if not schema.tag_has(tag):
		return "Tag '%s' not found" % tag

	if not entities.has(entity_key):
		return "Entity '%s' not found" % entity_key

	var entity := entities[entity_key]
	entity.tag_remove(tag)
	return ""


## Adds a relationship to the world between two entities with the given name and optional qualifier value.
func relationship_add(
	entity_key_a: StringName,
	relationship_name: StringName,
	entity_key_b: StringName,
	qualifier_value := &"",
) -> Array:
	var entity_type_a := entities[entity_key_a].type
	var entity_type_b := entities[entity_key_b].type
	var errors := schema.relationship_definition_validate(entity_type_a, relationship_name, entity_type_b, qualifier_value)
	if not errors.is_empty():
		return errors

	if not relationships.has([entity_key_a, entity_key_b]):
		relationships[[entity_key_a, entity_key_b]] = {}
	relationships[[entity_key_a, entity_key_b]][relationship_name] = RaconteurRelationship.new(entity_key_a, relationship_name, entity_key_b, qualifier_value)
	return []


func relationship_has(entity_key_a: StringName, relationship_name: StringName, entity_key_b: StringName, qualifier_value := &"") -> bool:
	var ok := relationships.has([entity_key_a, entity_key_b])
	ok = ok and relationships[[entity_key_a, entity_key_b]].has(relationship_name)
	if ok and not qualifier_value.is_empty():
		var relationship: RaconteurRelationship = relationships[[entity_key_a, entity_key_b]][relationship_name]
		ok = qualifier_value == relationship.qualifier_value
	return ok


func relationship_get(entity_key_a: StringName, relationship_name: StringName, entity_key_b: StringName) -> RaconteurRelationship:
	if not relationship_has(entity_key_a, relationship_name, entity_key_b):
		return null
	
	return relationships[[entity_key_a, entity_key_b]].get(relationship_name, null)


## Adds a global entity to the world with the given name and type.
## A global entity is one that is always present in the narration. Its key should be all caps.
func global_entity_add(entity_type: StringName, key: StringName, properties: Dictionary) -> Array:
	var errors := RaconteurEntity.validate(schema, key, entity_type, properties)
	if not errors.is_empty():
		return errors
	global_entities[key] = RaconteurEntity.new(key, entity_type, properties)
	return []


## Returns the global entity by key or null if it doesn't exist.
func global_entity_get(key: StringName) -> RaconteurEntity:
	return global_entities.get(key, null)
