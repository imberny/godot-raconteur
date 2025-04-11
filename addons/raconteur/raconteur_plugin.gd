@tool
extends EditorPlugin

const EDITOR_WINDOW = preload("./editor/editor.tscn")

var _editor_window: Control


func _enter_tree() -> void:
    _editor_window = EDITOR_WINDOW.instantiate()
    get_editor_interface().get_editor_main_screen().add_child(_editor_window)
    _editor_window.visible = false


func _exit_tree() -> void:
    get_editor_interface().get_editor_main_screen().remove_child(_editor_window)
    _editor_window.queue_free()


func _get_plugin_name() -> String:
    return "Raconteur"


func _has_main_screen() -> bool:
    return true


func _make_visible(is_visible: bool) -> void:
    if is_instance_valid(_editor_window):
        _editor_window.visible = is_visible