class_name RaconteurBeat


var schema: RaconteurSchema
var definition: RaconteurBeatDefinition
var alias_bindings: Dictionary[StringName, StringName]


func _init(schema_: RaconteurSchema, definition_: RaconteurBeatDefinition, alias_bindings_: Dictionary[StringName, StringName]) -> void:
    schema = schema_
    definition = definition_
    alias_bindings = alias_bindings_