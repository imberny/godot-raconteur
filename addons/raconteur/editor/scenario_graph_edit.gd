@tool
extends GraphEdit


var _popup: PopupMenu
var _click_position: Vector2
var _file: RaconteurFile
var _file_dialog: RaconteurFileDialog


func _ready() -> void:
    _setup_popup()
    _setup_file_dialog()
    _setup_graph()
    

func _setup_popup() -> void:
    popup_request.connect(_on_popup_request)
    _popup = PopupMenu.new()
    add_child(_popup)
    _popup.popup_window = true
    _popup.add_item("New node")
    _popup.index_pressed.connect(_on_popup_index_pressed)


func _setup_file_dialog() -> void:
    _file_dialog = RaconteurFileDialog.create()
    _file_dialog.file_selected.connect(_on_file_selected)
    add_child(_file_dialog)


func _setup_graph() -> void:
    connection_request.connect(_on_connection_request)


func _try_load_file(path: String) -> void:
    var file = load(path)
    if not file is RaconteurFile:
        push_error("File must be of type RaconteurFile.")
        return
    _file = file
    _display_file(_file)


func _display_file(file: RaconteurFile) -> void:
    var scenario_def_view := file.scenario_definition_views[0]
    for node in scenario_def_view.scenario_definition.scenario_nodes.values():
        var graph_node := ScenarioGraphNode.create()
        add_child(graph_node)
        graph_node.title = node.label
        graph_node.position_offset = scenario_def_view.node_position_offsets[node.id]


func _on_popup_request(at_position: Vector2) -> void:
    # User note at https://docs.godotengine.org/en/stable/classes/class_graphedit.html
    _click_position = (at_position + scroll_offset) / zoom
    # https://github.com/godotengine/godot/issues/95151
    var popup_position := get_screen_transform() * at_position
    _popup.popup(Rect2i(popup_position, Vector2i.ZERO))


func _on_popup_index_pressed(index: int) -> void:
    match index:
        0:
            _create_node(_click_position)
        _:
            push_error("Popup index %s not implemented!" % index)


func _create_node(at_position: Vector2) -> void:
    var graph_node := GraphNode.new()
    add_child(graph_node)
    graph_node.position_offset = at_position


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
    connect_node(from_node, from_port, to_node, to_port)


func _on_open_file_pressed() -> void:
    _file_dialog.popup_centered()


func _on_file_selected(file_path: String) -> void:
    _try_load_file(file_path)