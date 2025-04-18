@tool
extends Control

const ScenarioGraphEdit := preload("res://addons/raconteur/editor/scenario_graph_edit.gd")
const OPEN_FILE_DIALOG_SCENE := preload("res://addons/raconteur/editor/raconteur_open_file_dialog.tscn")

var _file: RaconteurFile
var _file_dialog: FileDialog
var _save_current_file_dialog: ConfirmationDialog
var _select_filepath_dialog: FileDialog

@onready var _graph_edit: ScenarioGraphEdit = %ScenarioGraphEdit


func _ready() -> void:
    _setup_file_dialog()
    _setup_confirmation_dialog()
    _setup_select_filepath_dialog()
    _graph_edit.changed.connect(_on_graph_edit_changed)


func is_dirty() -> bool:
    return _file and _file.is_dirty()


func save() -> void:
    if _file:
        _file.save()


func _setup_file_dialog() -> void:
    _file_dialog = FileDialog.new()
    _file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
    _file_dialog.file_selected.connect(_on_file_selected)
    add_child(_file_dialog)


func _setup_confirmation_dialog() -> void:
    _save_current_file_dialog = ConfirmationDialog.new()
    _save_current_file_dialog.dialog_text = "Save current file?"
    _save_current_file_dialog.confirmed.connect(_on_save_dialog_confirmed)
    _save_current_file_dialog.canceled.connect(_on_save_dialog_cancelled)
    _save_current_file_dialog.add_button("Do not save", false, "do not save")
    _save_current_file_dialog.custom_action.connect(_on_save_dialog_custom_action)
    add_child(_save_current_file_dialog)


func _setup_select_filepath_dialog() -> void:
    _select_filepath_dialog = FileDialog.new()
    _select_filepath_dialog.file_selected.connect(_on_new_file_filepath_selected)
    add_child(_select_filepath_dialog)


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
    _select_filepath_dialog.popup_centered()
    

func _try_save_and_create() -> void:
    if not _file or not _file.is_dirty():
        _create_new_file()
        return
    
    _save_current_file_dialog.popup_centered()


func _on_save_dialog_confirmed() -> void:
    save()
    _create_new_file()


func _on_save_dialog_cancelled() -> void:
    pass # do nothing?


func _on_save_dialog_custom_action(action: String) -> void:
    if "do not save" == action:
        _save_current_file_dialog.hide()
        _create_new_file()


func _on_open_file_pressed() -> void:
    _file_dialog.popup_centered()


func _on_file_selected(file_path: String) -> void:
    _try_load_file(file_path)


func _on_new_file_filepath_selected(file_path: String) -> void:
    _file = RaconteurFile.create()
    _file.take_over_path(file_path)
    _graph_edit.clear()


func _on_save_file_pressed() -> void:
    save()


func _on_new_file_pressed() -> void:
    _try_save_and_create()


func _on_graph_edit_changed() -> void:
    if _file:
        _file.set_dirty()


func _on_new_scenario_button_pressed() -> void:
    var scenario_definition := RaconteurScenarioDefinition.new()
    _file.scenario_definitions.append(scenario_definition)
    _graph_edit.display_scenario(scenario_definition)
