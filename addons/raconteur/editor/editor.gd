@tool
extends Control

const ScenarioGraphEdit := preload("res://addons/raconteur/editor/scenario_graph_edit.gd")
const RaconteurOpenFileDialog := preload("res://addons/raconteur/editor/raconteur_open_file_dialog.gd")

var _file: RaconteurFile
var _file_dialog: RaconteurOpenFileDialog

@onready var _graph_edit: ScenarioGraphEdit = %ScenarioGraphEdit


func _ready() -> void:
    _setup_file_dialog()
    _graph_edit.changed.connect(_on_graph_edit_changed)


func is_dirty() -> bool:
    return _file and _file.is_dirty()


func save() -> void:
    if _file:
        _file.save()


func _setup_file_dialog() -> void:
    _file_dialog = RaconteurOpenFileDialog.create()
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
    var scenario_definition := file.scenario_definitions[0]
    _graph_edit.display_scenario(scenario_definition)


func _create_new_file() -> void:
    _file = RaconteurFile.create()
    _graph_edit.clear()


func _try_save_current() -> void:
    if not _file or not _file.is_dirty():
        _create_new_file()
        return
    
    var dialog := ConfirmationDialog.new()
    dialog.dialog_text = "Save current file?"
    dialog.confirmed.connect(_on_save_dialog_confirmed)
    dialog.canceled.connect(_on_save_dialog_cancelled)
    dialog.add_button("Do not save", true, "do not save")
    dialog.custom_action.connect(_on_save_dialog_custom_action)


func _on_save_dialog_confirmed() -> void:
    save()
    _create_new_file()


func _on_save_dialog_cancelled() -> void:
    pass # do nothing?


func _on_save_dialog_custom_action(action: String) -> void:
    if "do not save" == action:
        _create_new_file()


func _on_open_file_pressed() -> void:
    _file_dialog.popup_centered()


func _on_file_selected(file_path: String) -> void:
    _try_load_file(file_path)


func _on_save_file_pressed() -> void:
    save()


func _on_new_file_pressed() -> void:
    _try_save_current()


func _on_graph_edit_changed() -> void:
    if _file:
        _file.set_dirty()


func _on_new_scenario_button_pressed() -> void:
    var scenario_definition := RaconteurScenarioDefinition.new()
    _file.scenario_definitions.append(scenario_definition)
    _graph_edit.display_scenario(scenario_definition)
