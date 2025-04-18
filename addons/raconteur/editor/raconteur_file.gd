@tool
class_name RaconteurFile extends Resource

@export var schema: RaconteurSchema
@export var scenario_definitions: Array[RaconteurScenarioDefinition]

var _is_dirty := false


static func create() -> RaconteurFile:
    var file := RaconteurFile.new()
    file.schema = RaconteurSchema.new()
    file.scenario_definitions = []
    return file


func is_dirty() -> bool:
    return _is_dirty


func set_dirty(is_dirty_ := true) -> void:
    _is_dirty = is_dirty_


func save() -> void:
    print(self.resource_path)
    ResourceSaver.save(self)
    set_dirty(false)