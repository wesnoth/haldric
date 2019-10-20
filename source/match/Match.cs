using Godot;
using System;

public class Match : Node2D
{

    // Child Nodes
    private Node2D scenario;

    public override void _Ready()
    {
        scenario = GetNode("Scenario") as Node2D;
        Scenario newScenario = GD.Load<PackedScene>("data/scenarios/Test.tscn").Instance() as Scenario;
        scenario.ReplaceBy(newScenario);
        scenario.Owner = this;
    }

}
