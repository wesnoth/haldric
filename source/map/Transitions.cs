using Godot;
using Godot.Collections;
using System;

public class Transitions : Node2D
{
    private TileSet tileSet = new TileSet();

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

    public void BuildTransitionsForLocation(Location loc, Array<Location> neighbors)
    {
        for (int i = 0; i < neighbors.Count;)
        {
            var n_loc = neighbors[i];

            if (n_loc == null || loc.Terrain.Layer >= n_loc.Terrain.Layer || !TileSetBuilder.HasTerrainTransition(n_loc.Terrain)) 
            { 
                i++;
                continue;
            }

            var directions = Hex.Directions[(Hex.Direction) i];
            var transitionName = GetTransitionName(n_loc.Terrain.BaseCode, neighbors, i);
            var chain = transitionName.Split("-").Length - 1;

            SetTile(loc.QuadCell, transitionName, i);

            // GD.Print(transitionName, "/", chain);

            i += chain;
        }
    }

    private string GetTransitionName(string code, Array<Location> neighbors, int layer)
    {
        var transitionName = code;

        // depending on how we go forward with this we might not need to go all around here.
        // for (int i = layer; i < neighbors.Count; i++) might be enough.
        for (int i = layer; i < layer + neighbors.Count; i++)
        {
            var n_loc = neighbors[i % neighbors.Count];

            if (n_loc == null)
            {
                return transitionName;
            }

            if (!code.Equals(n_loc.Terrain.BaseCode))
            {
                return transitionName;
            }

            var prev = transitionName;

            transitionName += "-" + Hex.Directions[(Hex.Direction) (i % neighbors.Count)];

            if (tileSet.FindTileByName(transitionName) == TileMap.InvalidCell)
            {
                // right now this prevents the transitions with 4 or greater directions to be used as the 4-direction transition tiles are missing as it seems
                return prev;
            }
        }

        return transitionName;
    }

    private void SetTile(Vector2 cell, string tileName, int layer)
    {
        var map = GetChildren()[layer] as TileMap;
        var tileId = map.TileSet.FindTileByName(tileName);
        map.SetCellv(cell, tileId);
    }
}
