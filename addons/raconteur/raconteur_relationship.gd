class_name RaconteurRelationship

var entity_a: StringName
var entity_b: StringName
var qualifier_property: StringName


func _init(entity_a_: StringName, entity_b_: StringName, qualifier_property_ := &"") -> void:
    entity_a = entity_a_
    entity_b = entity_b_
    qualifier_property = qualifier_property_


func is_eq(other: RaconteurRelationship) -> bool:
    return entity_a == other.entity_a and entity_b == other.entity_b and qualifier_property == other.qualifier_property