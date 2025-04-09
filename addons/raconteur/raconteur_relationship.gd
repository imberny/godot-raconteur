class_name RaconteurRelationship extends Resource

var relationship_name: StringName
var entity_a: StringName
var entity_b: StringName
var qualifier_value: StringName


func _init(relationship_name_: StringName, entity_a_: StringName, entity_b_: StringName, qualifier_value_ := &"") -> void:
    relationship_name = relationship_name_
    entity_a = entity_a_
    entity_b = entity_b_
    qualifier_value = qualifier_value_
