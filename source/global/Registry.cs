using Godot;
using System;
using Godot.Collections;

public class Registry : Node
{
    public static Dictionary<string, PackedScene> units = new Dictionary<string, PackedScene>();
    public static Dictionary<string, TerrainType> terrain = new Dictionary<string, TerrainType>();
    public static Dictionary<string, SheetData> terrainSheets = new Dictionary<string, SheetData>();
    public static Dictionary<string, AudioStream> music = new Dictionary<string, AudioStream>();


    public override void _Ready()
    {
        MakeUserDirectories();
        Scan();
    }

    public static bool HasUnit(string unitId)
    {
        return units.ContainsKey(unitId);
    }

    private void Scan()
    {
        LoadTerrain();
        LoadTerrainGraphics();
        LoadUnits();
        LoadMusic();
    }

    private void LoadUnits()
    {
        units.Clear();

        foreach (var fileData in FileLoader.LoadDirectory("res://data/units", new string[] {"tscn"}, true))
        {
            PackedScene unitType = fileData.data as PackedScene;
            units.Add(((UnitType)unitType.Instance()).Id, unitType);
        }
    }

    private void LoadMusic()
    {
        music.Clear();

        foreach (var fileData in FileLoader.LoadDirectory("res://audio/music", new string[] {"ogg", "wav"}, true))
        {
            music.Add(fileData.id, (AudioStream) fileData.data);
        }
    }
    
    private void LoadTerrain()
    {
        terrain.Clear();

        foreach (var fileData in FileLoader.LoadDirectory("res://data/terrain", new string[] {"tres"}, true))
        {
            TerrainType type = (TerrainType) fileData.data;
            terrain.Add(type.code, type);
        }
    }

        private void LoadTerrainGraphics()
    {
        terrainSheets.Clear();

        foreach (var fileData in FileLoader.LoadDirectory("res://data/terrain_graphics", new string[] {"tres"}, true))
        {
            SheetData data = (SheetData) fileData.data;
            terrainSheets.Add(fileData.id, data);
        }
    }

    private void MakeUserDirectories()
    {
        var userDirectory = new Directory();
        userDirectory.Open("user://");
        MakeScenarioDirectory(userDirectory);
    }

    private void MakeScenarioDirectory(Directory userDirectory)
    {
        if (!userDirectory.DirExists("data/editor/scenarios"))
        {
            userDirectory.MakeDir("data");
            userDirectory.MakeDir("data/editor");
            userDirectory.MakeDir("data/edtor/scenarios");
        }
    }
}
