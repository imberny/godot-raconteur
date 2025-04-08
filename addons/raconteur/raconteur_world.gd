class_name RaconteurWorld


var _schema: RaconteurSchema
var _entities: Dictionary[StringName, Dictionary] = {}


func _init(schema: RaconteurSchema) -> void:
    _schema = schema


func entity_add(name: StringName, properties: Dictionary) -> void:
    var ok := _schema.entity_validate(name, properties)
    if not ok:
        push_error("Entity '%s' does not match schema" % name)
        return
    
    _entities[name] = properties


func relationship_add(
    entity_a: StringName,
    entity_b: StringName,
    relationship_name: StringName,
    qualifier_value: StringName = "",
) -> void:
    pass