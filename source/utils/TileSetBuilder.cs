using Godot;
using Godot.Collections;
using System;

public class TileSetBuilder : Node
{
    class TerrainTransitionGraphic : Godot.Object
    {
        public int id;
        public string variation;
        public string directions;
        public Texture texture;
        public Vector2 offset;
    }
 
    class TerrainGraphic : Godot.Object
    {
        public int id;
        public string code;
        public Array<TerrainGraphic> variations = new Array<TerrainGraphic>();
        public Dictionary<string, Dictionary<string, TerrainTransitionGraphic>> transitions = new Dictionary<string, Dictionary<string, TerrainTransitionGraphic>>();
        public Texture texture;
    }

    private static Dictionary<string, Texture> spriteSheets = new Dictionary<string, Texture>();
    private static Dictionary<string, TerrainGraphic> terrainGraphics = new Dictionary<string, TerrainGraphic>();

    public static void AddSpriteSheet(string name, string path)
    {
        var sheet = GD.Load(path) as Texture;

        spriteSheets.Add(name, sheet);
    }

    public static TileSet Build()
    {
        var tileSet = new TileSet();

        foreach (var key in terrainGraphics.Keys)
        {
            var t = terrainGraphics[key];
            t.id = AddTile(tileSet, t.code, t.texture);

            for (int i = 0; i < t.variations.Count; i++)
            {
                var tv = t.variations[i];
                tv.id = AddTile(tileSet, tv.code + i + 1, tv.texture);
            }
        }

        return tileSet;
    }

    public static TileSet BuildTransitions()
    {
        var tileSet = new TileSet();
        
        foreach (var terrain in terrainGraphics.Keys)
        {
            var t = terrainGraphics[terrain];
            
            foreach (var variation in t.transitions.Keys)
            {
                var dict = t.transitions[variation];

                foreach (var directions in dict.Keys)
                {
                    var tt = dict[directions];

                    if (variation.Empty())
                    {
                        AddTile(tileSet, t.code + "-" + directions, tt.texture, tt.offset);
                    }
                    else
                    {
                        AddTile(tileSet, t.code + "-" + variation + "-" + directions, tt.texture, tt.offset);
                    }
                }
            }
        }
        return tileSet;
    }

    public static void CreateTerrainGraphic(string code, string sheetName, Rect2 region)
    {
        if (!spriteSheets.ContainsKey(sheetName)) 
        {
            GD.Print("TilSetBuilder: cannot add transition, no " + sheetName + " has been added yet!");
            return;
        }

        var tex = new AtlasTexture();

        tex.Atlas = spriteSheets[sheetName];
        tex.Region = region;

        if (terrainGraphics.ContainsKey(code))
        {
            var terrainGraphic = terrainGraphics[code];
            var variation = new TerrainGraphic();

            variation.texture = tex;
            variation.code = code;

            terrainGraphic.variations.Add(variation);
        }
        else
        {
            var terrainGraphic = new TerrainGraphic();

            terrainGraphic.texture = tex;
            terrainGraphic.code = code;

            terrainGraphics.Add(code, terrainGraphic);
        }
    }

    public static void CreateTerrainTransitionGraphic(string code, string sheetName, Rect2 region, Vector2 offset, string variation, string directions)
    {
        if (!terrainGraphics.ContainsKey(code)) 
        {
            GD.Print("TilSetBuilder: cannot add transition, no " + code + " has been added yet!");
            return;
        }

        if (!spriteSheets.ContainsKey(sheetName)) 
        {
            GD.Print("TilSetBuilder: cannot add transition, no " + sheetName + " has been added yet!");
            return;
        }

        var tex = new AtlasTexture();
        
        tex.Atlas = spriteSheets[sheetName];
        tex.Region = region;

        var terrainTransition = new TerrainTransitionGraphic();

        terrainTransition.directions = directions;
        terrainTransition.variation = variation;
        terrainTransition.texture = tex;
        terrainTransition.offset = offset;

        var terrain = terrainGraphics[code];
        
        if (!terrain.transitions.ContainsKey(variation))
        {
            terrain.transitions.Add(variation, new Dictionary<string, TerrainTransitionGraphic>());
        }

        terrain.transitions[variation].Add(directions, terrainTransition);
    }

    public static int GetVariationCount(string code)
    {
        if (!terrainGraphics.ContainsKey(code)) 
        {
            GD.Print("TilSetBuilder: Key " + code + " not found.");
            return 0;
        }
        return terrainGraphics[code].variations.Count;
    }

    public static bool HasVariation(string code)
    {
        if (!terrainGraphics.ContainsKey(code)) 
        {
            GD.Print("TilSetBuilder: Key " + code + " not found.");
            return false;
        }
        return terrainGraphics[code].variations.Count > 0;
    }

    public static Array<string> GetVariationArray(string code)
    {
        if (!terrainGraphics.ContainsKey(code)) 
        {
            GD.Print("TilSetBuilder: Key " + code + " not found.");
            return new Array<string>();
        }

        var variations = new Array<string> {code};
        var t = terrainGraphics[code];

        for (int i = 0; i < t.variations.Count; i++)
        {
            variations.Add( code + i + 1 );
        }

        return variations;
    }

    private static int AddTile(TileSet tileSet, string code, Texture texture, Vector2 offset = new Vector2())
    {
        var tileId = tileSet.GetTilesIds().Count;
        tileSet.CreateTile(tileId);
        tileSet.TileSetName(tileId, code);
        tileSet.TileSetTexture(tileId, texture);
        tileSet.TileSetTextureOffset(tileId, offset);
        return tileId;
    }
}
