using Godot;
using Godot.Collections;
using System;

public class Side : Node
{
    private int id;

    [Export] private string teamColor = "red";
    [Export] private string flagType = "standard";

    [Export] private int gold = 100;
    [Export] private int baseIncome = 2;

    [Export] private Vector2 startPosition = new Vector2();

    [Export] private Array<string> leader = new Array<string>();
    [Export] private Array<string> randomLeader = new Array<string>();
    [Export] private Array<string> recruit = new Array<string>();

    // Should probably be a dictionary with a unique ID as key
    private Array<Unit> units = new Array<Unit>();

    public override void _Ready()
    {
        id = GetIndex() + 1;
    }

    public void AssignUnit(Unit unit)
    {
        units.Add(unit);
    }
}
