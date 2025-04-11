@tool
extends GraphEdit


var _popup: PopupMenu
var _click_position: Vector2


func _ready() -> void:
    popup_request.connect(_on_popup_request)
    _popup = PopupMenu.new()
    add_child(_popup)
    _popup.popup_window = true
    _popup.add_item("New node")
    _popup.index_pressed.connect(_on_popup_index_pressed)


func _on_popup_request(at_position: Vector2) -> void:
    _click_position = at_position
    # https://github.com/godotengine/godot/issues/95151
    _popup.popup(Rect2i(get_screen_transform() * at_position, Vector2i.ZERO))


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