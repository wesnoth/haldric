using Godot;
using System;

public class Interface : Node2D
{

    Sprite cursor;
    Terrain terrain;
    bool showGrid = false;

    public override void _Ready()
    {
        cursor = (Sprite) GetNode("Cursor");
        terrain = (Terrain) GetNode("../Terrain");
    }

   public override void _Process(float delta)
   {
        // Update();
        cursor.SetPosition(terrain.WorldToWorldCentered(GetGlobalMousePosition()));
   }

   public override void _Draw()
   {
       // DRAW REACHABLE

       // DRAW PATH

       // DRAW CONNECTION GRID
   }
}
