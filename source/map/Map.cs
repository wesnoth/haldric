using Godot;
using Godot.Collections;
using System;

public class Map : TileMap
{
    private static PackedScene packedScene = GD.Load("res://source/map/Map.tscn") as PackedScene;
    public static Map Instance() { return packedScene.Instance() as Map; }

    const string DEFAULT_TERRAIN = "Gs";

    private MapData mapData = new MapData();

    private Dictionary<Vector3, Location> locations = new Dictionary<Vector3, Location>();

    public override void _Ready()
    {
        InitializeLocations();
        TileSet = TileSetBuilder.Build();
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

    public void SetLocationTerrain(Vector2 cell, Array<TerrainType> terrainType)
    {
        Vector3 cubeCell = Hex.Quad2Cube(cell);
        
        if (!locations.ContainsKey(cubeCell)) { return; }

        Location loc = locations[cubeCell];
        loc.Terrain = new Terrain(terrainType);
    }

    public void BuildTerrain()
    {
        Random rnd = new Random(10);

        foreach (var loc in locations.Values)
        {
            Vector2 cell = loc.QuadCell;
            string code = loc.Terrain.BaseCode;

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
                loc.Position = MapToWorld(quadCell);
                loc.Terrain = terrain;

                locations.Add(cubeCell, loc);
            }
        }
    }
}
