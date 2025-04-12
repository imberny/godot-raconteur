extends GutTest


func test_scenario():
    var scenario := RaconteurScenarioDefinition.new()

    scenario.alias_add(&"merchant", &"character")

    scenario.alias_add_new_entity(&"item", &"ring", {"name": &"Ring of Power", &"quality": &"superior"})

    scenario.new_relationship(&"merchant", &"ring", &"owns")

    scenario.constraint_add(RaconteurConstraintHasTag.new(&"PROTAGONIST", &"shopping"))

    var start_node := scenario.scenario_node_create()
    scenario.scenario_set_start_node(start_node.id)
    start_node.label = &"start"
    start_node.constraint_add(RaconteurConstraintHasTag.new(&"player", &"clever"))
    var second_node := scenario.scenario_node_create()
    second_node.label = &"second"
    var greetings_line := RaconteurLine.new()
    greetings_line.label = &"greetings"
    greetings_line.content = "Hello my fellow!"
    second_node.line_add(greetings_line)
    start_node.next_add(second_node.id)
    
    start_node.instruction_add(&"speak", [&"player", &"[greetings]"])

    assert_true(true)
