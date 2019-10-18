#if TOOLS
using Godot;
using System;

[Tool]
public class WesnothSDK : EditorPlugin
{
    public override void _EnterTree()
    {
        AddCustomType("UnitType", "Node2D", GD.Load<Script>("res://addons/wesnoth_sdk/unit/UnitType.cs"), null);

        AddCustomType("Defense", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Defense.cs"), null);
        AddCustomType("Movement", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Movement.cs"), null);
        AddCustomType("Resistance", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Resistance.cs"), null);
    
        AddCustomType("Attack", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Attack.cs"), null);
    }

    public override void _ExitTree()
    {
        RemoveCustomType("UnitType");

        RemoveCustomType("Defense");
        RemoveCustomType("Movement");
        RemoveCustomType("Resistance");
        
        RemoveCustomType("Attack");
    }
}
#endif