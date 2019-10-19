using Godot;
using System;

public class Movement : Node
{
    static private CSharpScript script = GD.Load<CSharpScript>("res://addons/wesnoth_sdk/unit/Movement.cs");
    public static Movement New() { return script.New() as Movement; }

    [Export] private int castle = 1;
    [Export] private int flat = 1;
    [Export] private int forest = 2;
    [Export] private int hills = 2;
    [Export] private int mountains = 3;
    [Export] private int village = 1; 
}
