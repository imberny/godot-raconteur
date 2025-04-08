class_name RaconteurProperty

enum Type {
	ENUM,
	ENTITY,
	INT,
	STRING,
	BOOL,
}


var _type: Type
var _enum_name: StringName


func _init(type: Type, enum_name := &""):
	_type = type
	_enum_name = enum_name


func type() -> Type:
	return _type


func enum_name() -> StringName:
	return _enum_name


func validate(schema: RaconteurSchema, value: Variant) -> bool:
	match _type:
		Type.ENUM:
			return schema.enum_validate(_enum_name, value)
		Type.ENTITY:
			return schema.entity_has(value)
		Type.INT:
			return value is int
		Type.STRING:
			return value is StringName
		Type.BOOL:
			return value is bool
	return false
