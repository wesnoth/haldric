using Godot;
using System;

[Tool]
public class Scenario : Node2D
{
    // Child Nodes
    private Node schedule;
    private Node2D sides;
    
    private Map map = new Map();

    public override void _EnterTree()
    {
        if(Engine.EditorHint)
        {
            if (GetNode("Schedule") as Node == null)
            {
                schedule = new Node();
                schedule.Name = "Schedule";
                GD.Print("Node added: ", schedule.Name);
                AddChild(schedule);
                schedule.Owner = this;
            }

            if (GetNode("Sides") as Node2D == null)
            {
                sides = new Node2D();
                sides.Name = "Units";
                GD.Print("Node added: ", sides.Name);
                AddChild(sides);
                sides.Owner = this;
            }

        }
    }

    public override void _Ready()
    {
        schedule = GetNode("Schedule") as Node;
        sides = GetNode("Sides") as Node2D;
        
        AddChild(map);
        map.Owner = this;
    }
}