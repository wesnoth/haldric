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
		Update();
		cursor.SetPosition(terrain.WorldToWorldCentered(GetGlobalMousePosition()));
   }

   public override void _Draw()
	{
		// DRAW REACHABLE
		foreach(var cell in terrain.GetReachableCellsU(terrain.GetUnit()))
		{
			Vector2 position = terrain.MapToWorldCentered(cell);
			DrawCircle(position, 5, new Color(255, 255, 255));
		}

		// DRAW PATH
		for (int i = 0; i < terrain.GetUnitPath().Count; i++)
		{
			DrawCircle(terrain.MapToWorldCentered(terrain.GetUnitPathPoint(i)), 5, new Color(255, 0, 0));
		}
   }
}
