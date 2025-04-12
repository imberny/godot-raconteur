static func schema() -> RaconteurSchema:
	var schema_ := RaconteurSchema.new()
	
	schema_.enum_add(&"genders", [&"male", &"female"])
	schema_.enum_add(&"wealth levels", [&"destitute", &"poor", &"well off", &"rich", &"opulent"])
	schema_.enum_add(&"friendliness", [&"enemy", &"rival", &"neutral", &"friend", &"ally"])
	
	schema_.property_add(&"name", RaconteurProperty.Type.STRING)
	schema_.property_add(&"gender", RaconteurProperty.Type.ENUM, &"genders")
	schema_.property_add(&"age", RaconteurProperty.Type.INT)
	schema_.property_add(&"wealth", RaconteurProperty.Type.ENUM, &"wealth levels")
	
	schema_.entity_add(&"character", [&"name", &"gender", &"age", &"wealth"])
	schema_.entity_add(&"city", [&"name"])
	
	schema_.relationship_definition_add(&"character", &"knows", &"character", &"friendliness")
	schema_.relationship_definition_add(&"character", &"in", &"city")
	schema_.relationship_definition_add(&"character", &"employs", &"character")
	
	schema_.tag_add(&"pretty")

	schema_.instruction_definition_add("speak", [&"character", &"character", &"line"] as Array[StringName])

	return schema_


static func alice_and_bob_world(schema_) -> RaconteurWorld:
	var world_ := RaconteurWorld.new(schema_)
	world_.entity_add(&"character", &"alice", {
		&"name": &"Alice",
		&"gender": &"female",
		&"age": 30,
		&"wealth": &"rich",
	})
	world_.entity_add(&"character", &"bob", {
		&"name": &"Bob",
		&"gender": &"male",
		&"age": 25,
		&"wealth": &"poor",
	})
	world_.entity_add(&"city", &"rotterdam", {
		&"name": &"Rotterdam",
	})
	world_.relationship_add(&"alice", &"knows", &"bob", &"neutral")
	world_.relationship_add(&"alice", &"employs", &"bob")
	world_.relationship_add(&"alice", &"in", &"rotterdam")
	world_.relationship_add(&"bob", &"in", &"rotterdam")

	world_.global_entity_add(&"character", &"PROTAGONIST", {
		&"name": &"Player McPlay",
		&"gender": &"male",
		&"age": 20,
		&"wealth": &"destitute",
	})

	return world_


static func scenario_definitions() -> Array[RaconteurScenarioDefinition]:
	var scenario_list: Array[RaconteurScenarioDefinition] = []

	var messenger_scenario := RaconteurScenarioDefinition.new()
	messenger_scenario.alias_add(&"messenger", &"character")
	messenger_scenario.alias_add(&"wealthy woman", &"character")
	messenger_scenario.constraint_add(
		RaconteurConstraintHasRelationship.new(
			&"wealthy woman", &"employs", &"messenger"
		)
	)
	messenger_scenario.constraint_add(RaconteurConstraintSet.new(
		&"wealthy woman", &"wealth", RaconteurConstraintSet.Operator.ONE_OF, [&"rich", &"opulent"]
	))
	var messenger_start_node := messenger_scenario.scenario_node_create()
	messenger_scenario.scenario_set_start_node(messenger_start_node.id)
	messenger_start_node.label = &"start"
	var greetings_line := RaconteurLine.new()
	greetings_line.label = &"greetings"
	greetings_line.content = "Hello, {PROTAGONIST.name}. I bear a message from Mme {wealthy woman.name}."
	messenger_start_node.line_add(greetings_line)
	messenger_start_node.instruction_add(&"speak", [&"messenger", &"PROTAGONIST", &"greetings"])
	var accept_node := messenger_scenario.scenario_node_create()
	messenger_start_node.next_add(accept_node.id)
	accept_node.label = &"accept message"
	var accept_line := RaconteurLine.new()
	accept_line.label = &"accept"
	accept_line.content = "Ok, let's hear it."
	accept_node.line_add(accept_line)
	accept_node.instruction_add(&"speak", [&"PROTAGONIST", &"messenger", &"accept"])
	var refuse_node := messenger_scenario.scenario_node_create()
	messenger_start_node.next_add(refuse_node.id)
	refuse_node.label = &"refuse message"
	var refuse_line := RaconteurLine.new()
	refuse_line.label = &"refuse"
	refuse_line.content = "Tell Mme {wealthy woman.name} I'm not interested."
	refuse_node.line_add(refuse_line)
	refuse_node.instruction_add(&"speak", [&"PROTAGONIST", &"messenger", &"refuse"])

	scenario_list.append(messenger_scenario)

	var non_matching_scenario := RaconteurScenarioDefinition.new()
	non_matching_scenario.alias_add(&"no match", &"character")
	non_matching_scenario.constraint_add(RaconteurConstraintHasTag.new(&"no match", &"unmatched tag"))

	scenario_list.append(non_matching_scenario)

	return scenario_list
