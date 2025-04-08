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


func validate(schema: RaconteurSchema, value: Variant) -> String:
    var error := ""
    match _type:
        Type.ENUM:
            error = schema.enum_validate(_enum_name, value)
        Type.ENTITY:
            if not schema.entity_has(value):
                error = "Entity '%s' not found" % value
        Type.INT:
            if not value is int:
                error = "Expected int, got %s" % value
        Type.STRING:
            if not (value is String or value is StringName):
                error = "Expected String, got %s" % value
        Type.BOOL:
            if not value is bool:
                error = "Expected bool, got %s" % value
    return error
