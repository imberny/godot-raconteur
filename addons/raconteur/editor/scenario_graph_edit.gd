@tool
extends GraphEdit


var _popup: PopupMenu
var _click_position: Vector2
var _scenario_def_view: RaconteurScenarioDefinitionView


func _ready() -> void:
    _setup_popup()
    _setup_graph()
    

func _setup_popup() -> void:
    popup_request.connect(_on_popup_request)
    _popup = PopupMenu.new()
    add_child(_popup)
    _popup.popup_window = true
    _popup.add_item("New node")
    _popup.index_pressed.connect(_on_popup_index_pressed)


func _setup_graph() -> void:
    connection_request.connect(_on_connection_request)


func display_scenario(scenario_definition_view: RaconteurScenarioDefinitionView) -> void:
    _scenario_def_view = scenario_definition_view
    for child in get_children().filter(func(c): return c is GraphNode):
        child.queue_free()
    for node in _scenario_def_view.scenario_definition.scenario_nodes.values():
        var graph_node := ScenarioGraphNode.create(node)
        add_child(graph_node)
        graph_node.position_offset = _scenario_def_view.node_position_offsets[node.id]


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
    var scenario_node := _scenario_def_view.scenario_definition.scenario_node_create()
    var graph_node := ScenarioGraphNode.create(scenario_node)
    add_child(graph_node)
    graph_node.position_offset = at_position


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
    connect_node(from_node, from_port, to_node, to_port)
