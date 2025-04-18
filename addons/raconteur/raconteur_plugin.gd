@tool
extends EditorPlugin

const EDITOR_WINDOW = preload("./editor/editor.tscn")
const RaconteurEditor = preload("res://addons/raconteur/editor/editor.gd")

var _editor_window: RaconteurEditor


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


func _get_unsaved_status(for_scene: String) -> String:
	if for_scene.is_empty() and _editor_window.is_dirty():
		return "Save your changes to Raconteur file before closing?"
	return ""


func _save_external_data() -> void:
	print("saving")
	_editor_window.save()