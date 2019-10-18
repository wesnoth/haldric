using Godot;
using Godot.Collections;
using System;

public class TileSetBuilder : Node
{
    class TerrainGraphic : Godot.Object
    {
        public int id;
        public string code;
        public Array<TerrainGraphic> variations = new Array<TerrainGraphic>();
        public Texture texture;
    }

    private static Dictionary<string, Texture> spriteSheets = new Dictionary<string, Texture>();
    private static Dictionary<string, TerrainGraphic> terrainGraphics = new Dictionary<string, TerrainGraphic>();

    public static void AddSpriteSheet(string name, string path)
    {
        Texture sheet = GD.Load(path) as Texture;

        spriteSheets.Add(name, sheet);
    }

    public static TileSet Build()
    {
        TileSet tileSet = new TileSet();

        foreach (var key in terrainGraphics.Keys)
        {
            TerrainGraphic t = terrainGraphics[key];
            t.id = AddTile(tileSet, t.code, t.texture);

            for (int i = 0; i < t.variations.Count; i++)
            {
                TerrainGraphic tv = t.variations[i];
                tv.id = AddTile(tileSet, tv.code + i + 1, tv.texture);
            }
        }

        return tileSet;
    }

    public static void CreateTerrainGraphic(string code, string sheetName, Rect2 region)
    {

        AtlasTexture tex = new AtlasTexture();

        tex.Atlas = spriteSheets[sheetName];
        tex.Region = region;

        if (terrainGraphics.ContainsKey(code))
        {
            TerrainGraphic terrainGraphic = terrainGraphics[code];
            TerrainGraphic variation = new TerrainGraphic();

            variation.texture = tex;
            variation.code = code;

            terrainGraphic.variations.Add(variation);
        }
        else
        {
            TerrainGraphic terrainGraphic = new TerrainGraphic();

            terrainGraphic.texture = tex;
            terrainGraphic.code = code;

            terrainGraphics.Add(code, terrainGraphic);
        }
    }

    public static int GetVariationCount(string code)
    {
        return terrainGraphics[code].variations.Count;
    }

    public static bool HasVariation(string code)
    {
        return terrainGraphics[code].variations.Count > 0;
    }

    public static Array<string> GetVariationArray(string code)
    {
        Array<string> variations = new Array<string> {code};
        TerrainGraphic t = terrainGraphics[code];

        for (int i = 0; i < t.variations.Count; i++)
        {
            variations.Add( code + i + 1 );
        }

        return variations;
    }

    private static int AddTile(TileSet tileSet, string code, Texture texture)
    {
        int tileId = tileSet.GetTilesIds().Count;
        tileSet.CreateTile(tileId);
        tileSet.TileSetName(tileId, code);
        tileSet.TileSetTexture(tileId, texture);
        return tileId;
    }
}
