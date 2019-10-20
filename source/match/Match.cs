using Godot;
using System;

public class Match : Node2D
{

    // Child Nodes
    private Controller controller;
    private Scenario scenario;

    public override void _Ready()
    {
        controller = GetNode("Controller") as Controller;

        var scenario_placeholder = GetNode("Scenario") as Node2D;
        scenario = GD.Load<PackedScene>("data/scenarios/Test.tscn").Instance() as Scenario;
        scenario_placeholder.ReplaceBy(scenario);
        scenario.Owner = this;

        controller.Scenario = scenario;
    }

}
