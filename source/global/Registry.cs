using Godot;
using System;
using Godot.Collections;

public class Registry : Node
{
    static public Dictionary<string, TerrainType> terrain = new Dictionary<string, TerrainType>();
    static public Dictionary<string, AudioStream> music = new Dictionary<string, AudioStream>();


    public override void _Ready()
    {
        MakeUserDirectories();
        Scan();
    }

    private void Scan()
    {
        LoadTerrain();
        LoadMusic();
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
