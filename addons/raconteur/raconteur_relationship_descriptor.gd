class_name RaconteurRelationshipDescriptor extends Resource

var relationship_name: StringName
var entity_type_a: StringName
var entity_type_b: StringName
var qualifier_property: StringName


func _init(entity_type_a_: StringName, relationship_name_: StringName, entity_type_b_: StringName, qualifier_property_ := &"") -> void:
	relationship_name = relationship_name_
	entity_type_a = entity_type_a_
	entity_type_b = entity_type_b_
	qualifier_property = qualifier_property_


func is_eq(other: RaconteurRelationshipDescriptor) -> bool:
	return entity_type_a == other.entity_type_a and entity_type_b == other.entity_type_b and qualifier_property == other.qualifier_property


func validate(schema: RaconteurSchema, entity_type_a: StringName, entity_type_b: StringName, qualifier_value: StringName) -> Array:
	var errors := []
	if not schema.entity_has(entity_type_a):
		errors.append("Entity type '%s' not found" % entity_type_a)
	if not schema.entity_has(entity_type_b):
		errors.append("Entity type '%s' not found" % entity_type_b)
	if not schema.relationship_descriptors_get_between(entity_type_a, entity_type_b).has(relationship_name):
		errors.append("Relationship descriptor '%s' not found between '%s' and '%s'" % [relationship_name, entity_type_a, entity_type_b])
	if not schema.enum_validate(qualifier_property, qualifier_value):
		errors.append("Invalid value '%s' for relationship descriptor '%s'" % [qualifier_value, qualifier_property])
	return errors
