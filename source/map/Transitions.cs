using Godot;
using Godot.Collections;
using System;

public class Transitions : Node2D
{
    public void SetTileSet(TileSet tileSet) 
    {
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

    public void BuildTransitionsForLocation(Location loc, Array<Location> neighbors)
    {
        for (int i = 0; i < neighbors.Count; i++)
        {
            var n_loc = neighbors[i];

            if (n_loc == null) { 
                continue;
            }

            if (loc.Terrain.Layer >= n_loc.Terrain.Layer)
            {
                continue;
            }

            var directions = Hex.Directions[(Hex.Direction) i];
            var transitionName = n_loc.Terrain.BaseCode + "-" + directions;

            SetTile(loc.QuadCell, transitionName, i);
        }
    }

    private void SetTile(Vector2 cell, string tileName, int layer)
    {
        var map = GetChildren()[layer] as TileMap;
        var tileId = map.TileSet.FindTileByName(tileName);
        map.SetCellv(cell, tileId);
    }
}
