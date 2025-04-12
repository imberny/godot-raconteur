class_name RaconteurProperty extends Resource

enum Type {
	ENUM,
	ENTITY,
	INT,
	STRING,
}


@export var type: Type
@export var enum_name: StringName


func _init(type_: Type, enum_name_ := &""):
	type = type_
	enum_name = enum_name_


func validate(schema: RaconteurSchema, value: Variant) -> String:
	var error := ""
	match type:
		Type.ENUM:
			error = schema.enum_validate(enum_name, value)
		Type.ENTITY:
			if not schema.entity_has(value):
				error = "Entity '%s' not found" % value
		Type.INT:
			if not value is int:
				error = "Expected int, got %s" % value
		Type.STRING:
			if not (value is String or value is StringName):
				error = "Expected String, got %s" % value
	return error
