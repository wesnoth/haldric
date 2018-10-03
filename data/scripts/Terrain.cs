using Godot;
using System;

public class Terrain : TileMap
{
    Vector2 offset = new Vector2(36, 36);

    public override void _Ready()
    {
        // Called every time the node is added to the scene.
        // Initialization here
        
    }

//    public override void _Process(float delta)
//    {
//        // Called every frame. Delta is time since last frame.
//        // Update game logic here.
//        
//    }

    public Vector2 MapToWorldCentered(Vector2 cell)
    {
        return MapToWorld(cell) + offset;
    }

    public Vector2 WorldToWorldCentered(Vector2 position)
    {
        return MapToWorldCentered(WorldToMap(position));
    }
}
