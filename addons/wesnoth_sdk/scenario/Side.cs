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

    private Node2D units;
    private Node2D flags;

    public override void _Ready()
    {
        id = GetIndex() + 1;

        units = new Node2D();
        units.Name = "Units";
        AddChild(units);
        units.Owner = this;

        flags = new Node2D();
        flags.Name = "Flags";
        AddChild(flags);
        flags.Owner = this;
    }
}
