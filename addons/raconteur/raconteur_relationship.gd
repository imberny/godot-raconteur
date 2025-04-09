class_name RaconteurRelationship extends Resource

var relationship_name: StringName
var entity_a: StringName
var entity_b: StringName
var qualifier_value: StringName


func _init(entity_a_: StringName, relationship_name_: StringName, entity_b_: StringName, qualifier_value_ := &"") -> void:
    relationship_name = relationship_name_
    entity_a = entity_a_
    entity_b = entity_b_
    qualifier_value = qualifier_value_


func is_satisfied(world: RaconteurWorld, binds: Dictionary[StringName, StringName]) -> bool:
    var entity_a_key := binds[entity_a]
    var entity_b_key := binds[entity_b]
    return world.relationship_has(entity_a_key, entity_b_key, relationship_name, qualifier_value)