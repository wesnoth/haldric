using Godot;
using Godot.Collections;
using System;

public class Editor : Node2D
{
    
    private const string DEFAULT_ROOT_PATH = ""; 
    private const string DEFAULT_USER_PATH = "";
    
    private Vector2 DEFAULT_MAP_SIZE = new Vector2(40, 40); // theoretically const but can't since complex data type

    private string currentTile1 = "Gs";
    private string currentTile2 = "";
    
    private Map map = null;

    // Child Nodes
    private EditorHUD hud;
    private Node2D mapContainer;

    public override void _UnhandledInput(InputEvent @event)
    {
        if (Input.IsActionPressed("mouse_left"))
        {
            Vector2 cell = map.WorldToMap(GetGlobalMousePosition());
            map.SetLocationTerrain(cell, new Array<TerrainType> {Registry.terrain[currentTile1]});
            map.BuildTerrain();
        }
        else if (Input.IsActionJustReleased("mouse_left"))
        {
        }
    }
    public override void _Ready()
    {
        hud = GetNode("HUD") as EditorHUD;
        mapContainer = GetNode("MapContainer") as Node2D;

        Button button = GetNode("HUD/Save") as Button;
        button.Connect("pressed", this, "_OnButtonPressed");

        NewMap(MapData.New());
    }

    public void SetTile1(string name)
    {
        currentTile1 = name;
    }

    public void SetTile2(string name)
    {
        currentTile2 = name;
    }

    private void NewMap(MapData mapData)
    {
        RemoveMap();

        map = Map.Instance();
        map.MapData = mapData;
        mapContainer.AddChild(map);
    }

    private void RemoveMap()
    {
        if (map != null)
        {
            mapContainer.RemoveChild(map);
            map.QueueFree();
            map = null;
        }
    }

    private void _OnButtonPressed()
    {
        MapData mapData = map.MapData;
        CallDeferred("Save", mapData);
    }

    private void Save(MapData mapData)
    {
        // GD.Print(mapData.data);
        ResourceSaver.Save("res://data/maps/transitions.tres", mapData);
        GD.Print("Map Saved");
    }

}
