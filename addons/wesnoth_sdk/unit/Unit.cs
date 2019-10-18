using Godot;
using System;

public class Unit : Node2D
{
    private static PackedScene packedScene = GD.Load<PackedScene>("res://source/unit/Unit.tscn");
    public static Unit Instance() { return packedScene.Instance() as Unit; }

    private int health = 0;
    private int experience = 0;
    private int moves = 0;

    // Child Nodes
    private UnitType type;

    public Unit(UnitType type) 
    {
        this.type = type;
    }

    public override void _Ready()
    {
        AddChild(type);
        health = type.Health;
        moves = type.Moves;
    }
}
