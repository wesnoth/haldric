using Godot;
using System;

public class Test : Scenario
{
    public override void _Ready()
    {
        base._Ready();

        // Adding Units Here
        AddUnit(1, "Elvish Archer", 4, 4);
    }
}