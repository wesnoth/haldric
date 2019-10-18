using Godot;
using System.Collections.Generic;
using System;

public class Main : Node
{
    private class TileData
    {
        public string code;
        public string sheet;
        public Rect2 region;

        public TileData(string code, string sheet, Rect2 region)
        {
            this.code = code;
            this.sheet = sheet;
            this.region = region;
        }
    }

    private class TransitionData : TileData
    {
        public string variation;
        public string directions;
        public Vector2 offset;

        public TransitionData(string code, string sheet, Rect2 region, Vector2 offset, string variation, string directions) : base(code, sheet, region)
        {
            this.variation = variation;
            this.directions = directions;
            this.offset = offset;
        }
    }

    public override void _Ready()
    {

        // Register Spritesheets

        TileSetBuilder.AddSpriteSheet("grass", "res://graphics/images/terrain/grass.png");

        // Register Graphics

        new List<TileData> {
            new TileData("Gg", "grass", new Rect2(864, 0, 72, 72)), // Green
            new TileData("Gg", "grass", new Rect2(792, 72, 72, 72)), // Green 2
            new TileData("Gg", "grass", new Rect2(1008, 0, 72, 72)), // Green 3
            new TileData("Gg", "grass", new Rect2(792, 0, 72, 72)), // Green 4
            new TileData("Gg", "grass", new Rect2(576, 0, 72, 72)), // Green 5
            new TileData("Gg", "grass", new Rect2(432, 0, 72, 72)), // Green 6
            new TileData("Gg", "grass", new Rect2(144, 72, 72, 72)), // Green 7
            new TileData("Gg", "grass", new Rect2(1080, 72, 72, 72)), // Green 8
        }.ForEach(data => { TileSetBuilder.CreateTerrainGraphic(data.code, data.sheet, data.region); } );

        new List<TileData> {
            new TileData("Gs", "grass", new Rect2(864, 72, 72, 72)), // Semi Dry
            new TileData("Gs", "grass", new Rect2(648, 0, 72, 72)), // Semi Dry 2
            new TileData("Gs", "grass", new Rect2(432, 72, 72, 72)), // Semi Dry 3
            new TileData("Gs", "grass", new Rect2(864, 72, 72, 72)), // Semi Dry 4
            new TileData("Gs", "grass", new Rect2(936, 72, 72, 72)), // Semi Dry 5
            new TileData("Gs", "grass", new Rect2(288, 72, 72, 72)), // Semi Dry 6
        }.ForEach(data => { TileSetBuilder.CreateTerrainGraphic(data.code, data.sheet, data.region); } );

        TileSetBuilder.CreateTerrainGraphic("Gd", "grass", new Rect2(648, 72, 72, 72));
        TileSetBuilder.CreateTerrainGraphic("Gll", "grass", new Rect2(216, 72, 72, 72));

        // Register Transitions

        new List<TransitionData> {
            new TransitionData("Gg", "grass", new Rect2(288, 0, 72, 72), new Vector2(), "", "s-sw-nw-n-ne"),
            new TransitionData("Gg", "grass", new Rect2(360, 0, 72, 72), new Vector2(), "", "sw-nw-n-ne-se"),
            new TransitionData("Gg", "grass", new Rect2(504, 72, 72, 72), new Vector2(), "", "s-sw-nw-n-ne-se"),
            new TransitionData("Gg", "grass", new Rect2(576, 144, 72, 72), new Vector2(15, 0), "", "ne-se-s"),
            new TransitionData("Gg", "grass", new Rect2(864, 144, 72, 72), new Vector2(), "", "s-sw-nw"),
            new TransitionData("Gg", "grass", new Rect2(1080, 144, 72, 72), new Vector2(17, 0), "", "n-ne-se"),
            new TransitionData("Gg", "grass", new Rect2(0, 216, 72, 72), new Vector2(), "", "sw-nw-n"),
            new TransitionData("Gg", "grass", new Rect2(504, 216, 72, 72), new Vector2(0, 31), "", "se-s-sw"),
            new TransitionData("Gg", "grass", new Rect2(576, 216, 72, 72), new Vector2(), "", "nw-n-ne"),
            new TransitionData("Gg", "grass", new Rect2(936, 216, 72, 72), new Vector2(42, 0), "", "ne-se"),
            new TransitionData("Gg", "grass", new Rect2(1008, 216, 72, 72), new Vector2(), "", "sw-nw"),
            new TransitionData("Gg", "grass", new Rect2(720, 360, 72, 72), new Vector2(0, 60), "", "s"),
            new TransitionData("Gg", "grass", new Rect2(1080, 360, 72, 72), new Vector2(15, 31), "", "se-s"),
            new TransitionData("Gg", "grass", new Rect2(504, 432, 72, 72), new Vector2(0, 31), "", "s-sw"),
            new TransitionData("Gg", "grass", new Rect2(792, 432, 72, 72), new Vector2(16, 0), "", "n-ne"),
            new TransitionData("Gg", "grass", new Rect2(936, 432, 72, 72), new Vector2(), "", "nw-n"),
            new TransitionData("Gg", "grass", new Rect2(504, 576, 72, 72), new Vector2(0, 27), "", "sw"),
            new TransitionData("Gg", "grass", new Rect2(72, 648, 72, 72), new Vector2(42, 30), "", "se"),
            new TransitionData("Gg", "grass", new Rect2(288, 648, 72, 72), new Vector2(48, 0), "", "ne"),
            new TransitionData("Gg", "grass", new Rect2(360, 648, 72, 72), new Vector2(11, 0), "", "n"),
            new TransitionData("Gg", "grass", new Rect2(648, 648, 72, 72), new Vector2(), "", "nw"),
        }.ForEach(data => { TileSetBuilder.CreateTerrainTransitionGraphic(data.code, data.sheet, data.region, data.offset, data.variation, data.directions); } );
    }
}