using Godot;
using System;

[Tool]
public class Scenario : Node2D
{
    // Child Nodes
    private Node schedule;
    
    private Node2D mapContainer;
    private Node2D unitContainer;

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

            if (GetNode("MapContainer") as Node2D == null)
            {
                mapContainer = new Node2D();
                mapContainer.Name = "MapContainer";
                GD.Print("Node added: ", mapContainer.Name);
                AddChild(mapContainer);
                mapContainer.Owner = this;
            }

            if (GetNode("Units") as Node2D == null)
            {
                unitContainer = new Node2D();
                unitContainer.Name = "Units";
                GD.Print("Node added: ", unitContainer.Name);
                AddChild(unitContainer);
                unitContainer.Owner = this;
            }

        }
    }

    public override void _Ready()
    {
        
    }
}