using Godot;
using System;

public class Game : Node2D
{
    MoveHandler moveHandler;
    Terrain terrain;
    Node units;

    Unit selectedUnit;


    public override void _Ready()
    {
        moveHandler = (MoveHandler) GetNode("MoveHandler");
        terrain = (Terrain) GetNode("Terrain");
        units = (Node) GetNode("UnitContainer");

        var sprite = (Texture) ResourceLoader.Load("res://units/sprite.png");
        
        var unit1 = new Unit();
        var unit2 = new Unit();

        unit1.SetTexture(sprite);
        unit1.SetPosition(terrain.MapToWorldCentered(new Vector2(10, 3)));
        
        unit2.SetTexture(sprite);
        unit2.SetPosition(terrain.MapToWorldCentered(new Vector2(10, 12)));
        
        units.AddChild(unit1);
        units.AddChild(unit2);
    }

}
