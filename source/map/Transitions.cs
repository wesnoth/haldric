using Godot;
using Godot.Collections;
using System;

public class Transitions : Node2D
{
    private TileSet tileSet = new TileSet();

    public TileSet TileSet { get { return tileSet; } }

    public void SetTileSet(TileSet tileSet) 
    {
        this.tileSet = tileSet;

        foreach (TileMap map in GetChildren())
        {
            map.TileSet = tileSet;
        }
    }

    public void Clear()
    {
        foreach (TileMap map in GetChildren())
        {
            map.Clear();
        }
    }

    public void SetTile(Vector2 cell, string tileName, int layer)
    {
        var map = GetChildren()[layer] as TileMap;
        var tileId = map.TileSet.FindTileByName(tileName);
        map.SetCellv(cell, tileId);
    }
}
