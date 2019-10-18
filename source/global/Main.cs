using Godot;
using System.Collections.Generic;
using System;

public class Main : Node
{
    private struct Data
    {
        public string code;
        public string sheet;
        public Rect2 region;

        public Data(string code, string sheet, Rect2 region)
        {
            this.code = code;
            this.sheet = sheet;
            this.region = region;
        }
    }

    public override void _Ready()
    {

        // Register Spritesheets
        TileSetBuilder.AddSpriteSheet("grass", "res://graphics/images/terrain/grass.png");

        // Register Graphics
        new List<Data> {
            new Data("Gg", "grass", new Rect2(864, 0, 72, 72)), // Green
            new Data("Gg", "grass", new Rect2(792, 72, 72, 72)), // Green 2
            new Data("Gg", "grass", new Rect2(1008, 0, 72, 72)), // Green 3
            new Data("Gg", "grass", new Rect2(792, 0, 72, 72)), // Green 4
            new Data("Gg", "grass", new Rect2(576, 0, 72, 72)), // Green 5
            new Data("Gg", "grass", new Rect2(432, 0, 72, 72)), // Green 6
            new Data("Gg", "grass", new Rect2(144, 72, 72, 72)), // Green 7
            new Data("Gg", "grass", new Rect2(1080, 72, 72, 72)), // Green 8
        }.ForEach(data => { TileSetBuilder.CreateTerrainGraphic(data.code, data.sheet, data.region); } );

        new List<Data> {
            new Data("Gs", "grass", new Rect2(864, 72, 72, 72)), // Semi Dry
            new Data("Gs", "grass", new Rect2(648, 0, 72, 72)), // Semi Dry 2
            new Data("Gs", "grass", new Rect2(432, 72, 72, 72)), // Semi Dry 3
            new Data("Gs", "grass", new Rect2(864, 72, 72, 72)), // Semi Dry 4
            new Data("Gs", "grass", new Rect2(936, 72, 72, 72)), // Semi Dry 5
            new Data("Gs", "grass", new Rect2(288, 72, 72, 72)), // Semi Dry 6
        }.ForEach(data => { TileSetBuilder.CreateTerrainGraphic(data.code, data.sheet, data.region); } );

        TileSetBuilder.CreateTerrainGraphic("Gd", "grass", new Rect2(648, 72, 72, 72));
        // TileSetBuilder.CreateTerrainGraphic("Gs", "grass", new Rect2(864, 72, 72, 72));
        TileSetBuilder.CreateTerrainGraphic("Gll", "grass", new Rect2(216, 72, 72, 72));
    }
}

/*
[
    { name: "Gg", id: "grass", rect: new Rect2(864, 0, 72, 72) },
    { name: "Gg", id: "grass", rect: new Rect2(792, 0, 72, 72) },
    { name: "Gg", id: "grass", rect: new Rect2(576, 0, 72, 72) }
].forEach(([name, id, rect]) => TileSetBuilder.CreateTerrainCragic(name, id, rect));

 */