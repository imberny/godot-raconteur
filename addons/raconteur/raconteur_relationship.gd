class_name RaconteurRelationship

var relationship_name: StringName
var entity_a: StringName
var entity_b: StringName
var qualifier_property: StringName


func _init(relationship_name_: StringName, entity_a_: StringName, entity_b_: StringName, qualifier_property_ := &"") -> void:
    relationship_name = relationship_name_
    entity_a = entity_a_
    entity_b = entity_b_
    qualifier_property = qualifier_property_


func is_eq(other: RaconteurRelationship) -> bool:
    return entity_a == other.entity_a and entity_b == other.entity_b and qualifier_property == other.qualifier_property


func validate(schema: RaconteurSchema, entity_a: StringName, entity_b: StringName, qualifier_value: StringName) -> Array:
    var errors := []
    if not schema.entity_has(entity_a):
        errors.append("Entity '%s' not found" % entity_a)
    if not schema.entity_has(entity_b):
        errors.append("Entity '%s' not found" % entity_b)
    if not schema.relationships_get_between(entity_a, entity_b).has(relationship_name):
        errors.append("Relationship '%s' not found between '%s' and '%s'" % [relationship_name, entity_a, entity_b])
    if not schema.enum_validate(qualifier_property, qualifier_value):
        errors.append("Invalid value '%s' for relationship '%s'" % [qualifier_value, qualifier_property])
    return errors