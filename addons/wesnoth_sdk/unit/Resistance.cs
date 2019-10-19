using Godot;
using System;

public class Resistance : Node
{
    static private CSharpScript script = GD.Load<CSharpScript>("res://addons/wesnoth_sdk/unit/Resistance.cs");
    public static Resistance New() { return script.New() as Resistance; }

    [Export] private int blade = 0;
    [Export] private int pierce = 0;
    [Export] private int impact = 0;
    [Export] private int fire = 0;
    [Export] private int cold = 0;
    [Export] private int arcane = 0; 
}
