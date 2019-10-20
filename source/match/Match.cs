using Godot;
using System;

public class Match : Node2D
{

    // Child Nodes
    private Node2D scenarioContainer;

    public override void _Ready()
    {
        scenarioContainer = GetNode("ScenarioContainer") as Node2D;
        Scenario scenario = GD.Load<PackedScene>("data/scenarios/Test.tscn").Instance() as Scenario;
        scenarioContainer.AddChild(scenario);
        scenario.Owner = this;
    }

}
