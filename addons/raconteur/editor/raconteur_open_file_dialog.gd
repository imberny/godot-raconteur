extends FileDialog


static func create() -> FileDialog:
    var dialog: FileDialog = load("res://addons/raconteur/editor/raconteur_open_file_dialog.tscn").instantiate()
    return dialog