#if TOOLS
using Godot;
using System;

[Tool]
public class WesnothSDK : EditorPlugin
{
    public override void _EnterTree()
    {

        AddCustomType("Scenario", "Node2D", GD.Load<Script>("res://addons/wesnoth_sdk/scenario/Scenario.cs"), null);
        AddCustomType("Side", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/scenario/Side.cs"), null);
        
        AddCustomType("UnitType", "Node2D", GD.Load<Script>("res://addons/wesnoth_sdk/unit/UnitType.cs"), null);

        AddCustomType("Defense", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Defense.cs"), null);
        AddCustomType("Movement", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Movement.cs"), null);
        AddCustomType("Resistance", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Resistance.cs"), null);
    
        AddCustomType("Attack", "Node", GD.Load<Script>("res://addons/wesnoth_sdk/unit/Attack.cs"), null);
    }

    public override void _ExitTree()
    {
        RemoveCustomType("Scenario");
        RemoveCustomType("Side");

        RemoveCustomType("UnitType");

        RemoveCustomType("Defense");
        RemoveCustomType("Movement");
        RemoveCustomType("Resistance");
        
        RemoveCustomType("Attack");
    }
}
#endif