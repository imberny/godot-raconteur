class_name RaconteurFileDialog extends FileDialog


static func create() -> RaconteurFileDialog:
    var dialog: RaconteurFileDialog = load("res://addons/raconteur/editor/raconteur_file_dialog.tscn").instantiate()
    return dialog