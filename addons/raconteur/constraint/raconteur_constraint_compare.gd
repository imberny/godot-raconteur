class_name RaconteurConstraintCompare extends RaconteurConstraint

enum Operator {
	EQUALS,
	NOT_EQUALS,
	GREATER_THAN,
	GREATER_THAN_OR_EQUALS,
	LESS_THAN,
	LESS_THAN_OR_EQUALS,
}

var alias: StringName
var property: StringName
var operator: Operator
var other: Variant
var other_property: StringName


func _init(alias_: StringName, property_: StringName, operator_: Operator, other_: Variant, other_property_ := &"") -> void:
	alias = alias_
	property = property_
	operator = operator_
	other = other_
	other_property = other_property_


func is_satisfied(world: RaconteurWorld, binds: Dictionary[StringName, StringName]) -> bool:
	var entity_key := binds[alias]
	var entity: RaconteurEntity = world.entity_get(entity_key)
	if not entity:
		return false
	
	var value := other
	# A non empty other_property means other is an alias.
	if not other_property.is_empty():
		var other_entity_key := binds[other]
		var other_entity: RaconteurEntity = world.entity_get(other_entity_key)
		if not other_entity:
			return false
		value = other_entity.property_value(other_property)

	var property_value: Variant = entity.property_value(property)
	match operator:
		Operator.EQUALS:
			return property_value == value
		Operator.NOT_EQUALS:
			return property_value != value
		Operator.GREATER_THAN:
			return property_value > value
		Operator.GREATER_THAN_OR_EQUALS:
			return property_value >= value
		Operator.LESS_THAN:
			return property_value < value
		Operator.LESS_THAN_OR_EQUALS:
			return property_value <= value
	return false
