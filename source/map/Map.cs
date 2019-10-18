using Godot;
using Godot.Collections;
using System;

public class Map : TileMap
{
    private static PackedScene packedScene = GD.Load("res://source/map/Map.tscn") as PackedScene;
    public static Map Instance() { return packedScene.Instance() as Map; }
    public static Vector2 OFFSET = new Vector2(36, 36);

    const string DEFAULT_TERRAIN = "Gs";
    private MapData mapData = new MapData();

    private Dictionary<Vector3, Location> locations = new Dictionary<Vector3, Location>();

    // Child Nodes
    private Transitions transitions;

    public override void _Ready()
    {
        InitializeLocations();

        transitions = GetNode<Transitions>("Transitions");

        TileSet = TileSetBuilder.Build();
        transitions.SetTileSet(TileSetBuilder.BuildTransitions());
        
        BuildTerrain();
    }

    public MapData MapData 
    {
        get 
        { 
            mapData.Pack(locations);
            return mapData; 
        }
        set { mapData = value; }
    }

    public Vector2 MapToWorldCentered(Vector2 cell)
    {
        return MapToWorld(cell) + OFFSET;
    }

    public void SetLocationTerrain(Vector2 cell, Array<TerrainType> terrainType)
    {
        Vector3 cubeCell = Hex.Quad2Cube(cell);
        
        if (!locations.ContainsKey(cubeCell)) { return; }

        Location loc = locations[cubeCell];
        loc.Terrain = new Terrain(terrainType);
    }

    public void BuildTerrain()
    {
        transitions.Clear();

        Random rnd = new Random(0);

        foreach (var loc in locations.Values)
        {
            Vector2 cell = loc.QuadCell;
            string code = loc.Terrain.BaseCode;
            SetTileBase(rnd, cell, code);
            SetTileTransitions(loc);
        }
    }

    private void SetTileBase(Random rnd, Vector2 cell, string code)
    {
        if (TileSetBuilder.HasVariation(code))
        {
            Array<string> variations = TileSetBuilder.GetVariationArray(code);
            int rand = rnd.Next(0, variations.Count);
            string tileName = variations[rand];
            SetCellv(cell, TileSet.FindTileByName(tileName));
        }
        else
        {
            rnd.Next();
            SetCellv(cell, TileSet.FindTileByName(code));
        }
    }

    private void SetTileTransitions(Location loc)
    {
        transitions.BuildTransitionsForLocation(loc, GetNeighborLocations(loc));
    }

    private Array<Location> GetNeighborLocations(Location loc)
    {
        return GetNeighborLocations(loc.QuadCell);
    }

        private Array<Location> GetNeighborLocations(Vector2 cell)
    {
        var n_locs = new Array<Location>();

        var neighbors = Hex.GetNeighbors(cell);

        foreach (var n_cell in neighbors)
        {
            n_locs.Add(GetLocation(n_cell));
        }

        return n_locs;
    }

    private Location GetLocation(Vector2 cell)
    {
        return GetLocation(Hex.Quad2Cube(cell));
    }

    private Location GetLocation(Vector3 cube)
    {
        if (!locations.ContainsKey(cube))
        {
            return null;
        }

        return locations[cube];
    }

    private void InitializeLocations()
    {
        locations.Clear();

        if (mapData == null) { return; }

        for (int y = 0; y < mapData.height; y++)
        {
            for (int x = 0; x < mapData.width; x++)
            {
                Vector2 quadCell = new Vector2(x, y);
                Vector3 cubeCell = Hex.Quad2Cube(quadCell);

                Array<string> code = new Array<string>();

                if (mapData.data.ContainsKey(cubeCell))
                {
                    code = mapData.data[cubeCell];
                }
                else
                {
                    code.Add(DEFAULT_TERRAIN);
                }

                Array<TerrainType> terrainTypes = new Array<TerrainType>();

                foreach (var c in code)
                {
                    terrainTypes.Add(Registry.terrain[c]);
                }

                Terrain terrain = new Terrain(terrainTypes);
                Location loc = new Location();
                loc.CubeCell = cubeCell;
                loc.QuadCell = quadCell;
                loc.Position = MapToWorldCentered(quadCell);
                loc.Terrain = terrain;

                locations.Add(cubeCell, loc);
            }
        }
    }

    // public override void _Draw()
    // {
    //     foreach (var loc in locations.Values)
    //     {
    //         var neighbors = Hex.GetNeighbors(loc.QuadCell);
            
    //         foreach (var n in neighbors)
    //         {
    //             DrawLine(loc.Position, MapToWorldCentered(n), new Color("FFFFFF"), 3);
    //         }
    //     }
    // }
}
