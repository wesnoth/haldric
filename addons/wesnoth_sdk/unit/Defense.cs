using Godot;
using System;

public class Defense : Node
{
    static private CSharpScript script = GD.Load<CSharpScript>("res://addons/wesnoth_sdk/unit/Defense.cs");
    public static Defense New() { return script.New() as Defense; }
    
    [Export] private int castle = 50;
    [Export] private int flat = 50;
    [Export] private int forest = 50;
    [Export] private int hills = 50;
    [Export] private int mountains = 50;
    [Export] private int village = 50;
}
