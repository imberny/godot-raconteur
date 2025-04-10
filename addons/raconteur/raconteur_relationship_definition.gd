class_name RaconteurRelationshipDefinition extends Resource

var relationship_name: StringName
var entity_type_a: StringName
var entity_type_b: StringName
var qualifier_enum: StringName


func _init(entity_type_a_: StringName, relationship_name_: StringName, entity_type_b_: StringName, qualifier_enum_ := &"") -> void:
	relationship_name = relationship_name_
	entity_type_a = entity_type_a_
	entity_type_b = entity_type_b_
	qualifier_enum = qualifier_enum_


func is_eq(other: RaconteurRelationshipDefinition) -> bool:
	return entity_type_a == other.entity_type_a and entity_type_b == other.entity_type_b and qualifier_enum == other.qualifier_enum


func validate(schema: RaconteurSchema, entity_type_a: StringName, entity_type_b: StringName, qualifier_value: StringName) -> Array:
	var errors := []
	if not schema.entity_has(entity_type_a):
		errors.append("Entity type '%s' not found" % entity_type_a)
	if not schema.entity_has(entity_type_b):
		errors.append("Entity type '%s' not found" % entity_type_b)
	if not schema.relationship_definitions_get_between(entity_type_a, entity_type_b).has(relationship_name):
		errors.append("Relationship definition '%s' not found between '%s' and '%s'" % [relationship_name, entity_type_a, entity_type_b])
	if qualifier_enum:
		var error := schema.enum_validate(qualifier_enum, qualifier_value)
		if not error.is_empty():
			errors.append(error)
	return errors
