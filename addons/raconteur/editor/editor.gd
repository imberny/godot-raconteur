@tool
extends Control

const ScenarioGraphEdit := preload("res://addons/raconteur/editor/scenario_graph_edit.gd")

var _file: RaconteurFile
var _file_dialog: RaconteurFileDialog

@onready var _graph_edit: ScenarioGraphEdit = %ScenarioGraphEdit


func _ready() -> void:
    _setup_file_dialog()


func _setup_file_dialog() -> void:
    _file_dialog = RaconteurFileDialog.create()
    _file_dialog.file_selected.connect(_on_file_selected)
    add_child(_file_dialog)


func _try_load_file(path: String) -> void:
    var file = ResourceLoader.load(path)
    if not file is RaconteurFile:
        push_error("File must be of type RaconteurFile.")
        return
    _load_file(file)


func _load_file(file: RaconteurFile) -> void:
    _file = file
    var scenario_def_view := file.scenario_definition_views[0]
    _graph_edit.display_scenario(scenario_def_view)
    

func _on_open_file_pressed() -> void:
    _file_dialog.popup_centered()


func _on_file_selected(file_path: String) -> void:
    _try_load_file(file_path)


func _on_save_file_pressed() -> void:
    if _file:
        ResourceSaver.save(_file)
