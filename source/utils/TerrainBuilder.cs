using Godot;
using Godot.Collections;
using System;

public class TerrainBuilder : Node
{
    public static void Build(Map map)
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
        BuildTransitionsForLocation(map.Transitions, loc, map.GetNeighborLocations(loc));
    }

    private static void BuildTransitionsForLocation(Transitions transitions, Location loc, Array<Location> neighbors)
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
            var transitionName = GetTransitionName(transitions, n_loc.Terrain.BaseCode, neighbors, i);
            var chain = transitionName.Split("-").Length - 1;

            transitions.SetTile(loc.QuadCell, transitionName, i);

            // GD.Print(transitionName, "/", chain);

            i += chain;
        }
    }

    private static string GetTransitionName(Transitions transitions, string code, Array<Location> neighbors, int layer)
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

            if (transitions.TileSet.FindTileByName(transitionName) == TileMap.InvalidCell)
            {
                // right now this prevents the transitions with 4 or greater directions to be used as the 4-direction transition tiles are missing as it seems
                return prev;
            }
        }

        return transitionName;
    }
}
