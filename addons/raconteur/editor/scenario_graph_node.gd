@tool
class_name ScenarioGraphNode extends GraphNode

const SCENE_PATH := "res://addons/raconteur/editor/scenario_graph_node.tscn"


var scenario_node: RaconteurScenarioNode


static func create(scenario_node_: RaconteurScenarioNode) -> ScenarioGraphNode:
    var node: ScenarioGraphNode = load(SCENE_PATH).instantiate()
    node.scenario_node = scenario_node_
    return node


func _ready() -> void:
    if not scenario_node:
        return
    title = scenario_node.label