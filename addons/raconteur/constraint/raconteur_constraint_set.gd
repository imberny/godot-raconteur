class_name RaconteurConstraintSet extends RaconteurConstraint

enum Operator {
	ONE_OF,
	NONE_OF,
}

var alias: StringName
var property: StringName
var operator: Operator
var values: Array


func _init(alias_: StringName, property_: StringName, operator_: Operator, values_: Array) -> void:
	alias = alias_
	property = property_
	operator = operator_
	values = values_


func is_satisfied(world: RaconteurWorld, binds: Dictionary[StringName, StringName]) -> bool:
	var entity_key := binds[alias]
	var entity: RaconteurEntity = world.entity_get(entity_key)
	if not entity:
		return false

	var property_value: Variant = entity.property_value(property)
	match operator:
		Operator.ONE_OF:
			return values.has(property_value)
		Operator.NONE_OF:
			return not values.has(property_value)
	return false
