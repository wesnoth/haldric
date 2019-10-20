using Godot;
using System;

[Tool]
public class Scenario : Node2D
{  
    private Map map = Map.Instance();

    [Export] string schedule = "default";

    [Export] MapData mapData;

    // Child Nodes
    private Node sides;

    public override void _EnterTree()
    {
        if(Engine.EditorHint)
        {
            if (GetNode("Sides") as Node == null)
            {
                sides = new Node();
                sides.Name = "Sides";
                GD.Print("Node added: ", sides.Name);
                AddChild(sides);
                sides.Owner = this;
            }
        }
    }

    public override void _Ready()
    {
        sides = GetNode("Sides") as Node2D;
        
        if (mapData == null)
        {
            mapData = MapData.New();
        }

        map.MapData = mapData;
        AddChild(map);
    }
}