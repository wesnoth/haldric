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

    public Transitions Transitions { get { return transitions; } }

    public Dictionary<Vector3, Location> Locations { get { return locations; } }

    public override void _Ready()
    {
        InitializeLocations();

        transitions = GetNode<Transitions>("Transitions");

        TileSet = TileSetBuilder.BuildTerrainTileSet();
        transitions.SetTileSet(TileSetBuilder.BuildTransitionTileSet());
        
        TerrainBuilder.Build(this);
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

    public Array<Location> GetNeighborLocations(Location loc)
    {
        return GetNeighborLocations(loc.QuadCell);
    }

    public Array<Location> GetNeighborLocations(Vector2 cell)
    {
        var n_locs = new Array<Location>();

        var neighbors = Hex.GetNeighbors(cell);

        foreach (var n_cell in neighbors)
        {
            n_locs.Add(GetLocation(n_cell));
        }

        return n_locs;
    }

    public Location GetLocation(Vector2 cell)
    {
        return GetLocation(Hex.Quad2Cube(cell));
    }

    public Location GetLocation(Vector3 cube)
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
