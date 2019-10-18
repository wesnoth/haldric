using Godot;
using Godot.Collections;
using System;

public class MapData : Resource
{
    private static CSharpScript script = GD.Load<CSharpScript>("res://source/map/MapData.cs");
    public static MapData New() { return script.New() as MapData; }

    [Export] public int width = 40;
    [Export] public int height = 40;

    [Export] public Dictionary<Vector3, Array<string>> data = new Dictionary<Vector3, Array<string>>();

    public void Pack(Dictionary<Vector3, Location> locations)
    {
        data.Clear();

        width = 0;
        height = 0;
        
        foreach (var loc in locations.Values)
        {
            data.Add(loc.CubeCell, loc.Terrain.Code);
            width = Mathf.Max(width, (int) loc.QuadCell.x + 1);
            height = Mathf.Max(height, (int) loc.QuadCell.y + 1);
        }
    }
}
