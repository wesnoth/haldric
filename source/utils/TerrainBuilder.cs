using Godot;
using Godot.Collections;
using System;

public class TerrainBuilder : Node
{
    public static void BuildTerrain(Map map)
    {

        map.Transitions.Clear();

        Random rnd = new Random(0);

        foreach (var loc in map.Locations.Values)
        {
            Vector2 cell = loc.QuadCell;
            string code = loc.Terrain.BaseCode;
            SetTileBase(map, rnd, cell, code);
            SetTileTransitions(map, loc);
        }
    }

    public static void BuildTransitions(Map map)
    {
        throw new NotImplementedException();
    }

    private static void SetTileBase(Map map, Random rnd, Vector2 cell, string code)
    {
        if (TileSetBuilder.HasVariation(code))
        {
            Array<string> variations = TileSetBuilder.GetVariationArray(code);
            int rand = rnd.Next(0, variations.Count);
            string tileName = variations[rand];
            map.SetCellv(cell, map.TileSet.FindTileByName(tileName));
        }
        else
        {
            rnd.Next();
            map.SetCellv(cell, map.TileSet.FindTileByName(code));
        }
    }

    private static void SetTileTransitions(Map map, Location loc)
    {
        map.Transitions.BuildTransitionsForLocation(loc, map.GetNeighborLocations(loc));
    }
}
