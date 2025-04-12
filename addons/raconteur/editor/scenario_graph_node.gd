class_name ScenarioGraphNode extends GraphNode

const SCENE_PATH := "res://addons/raconteur/editor/scenario_graph_node.tscn"


static func create() -> ScenarioGraphNode:
    var node: ScenarioGraphNode = load(SCENE_PATH).instantiate()
    return node