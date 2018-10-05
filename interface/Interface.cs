using Godot;
using System;

public class Interface : Node2D
{

	Sprite cursor;
	Game game;
	Terrain terrain;
	bool showGrid = false;

	public override void _Ready()
	{
		cursor = (Sprite)GetNode("Cursor");
		game = (Game)GetNode("..");
		terrain = (Terrain)GetNode("../Terrain");
	}

   public override void _Process(float delta)
   {
		Update();
		cursor.SetPosition(terrain.WorldToWorldCentered(GetGlobalMousePosition()));
   }

   public override void _Draw()
	{
		if (game.GetSelectedUnit() != null)
		{
			// DRAW REACHABLE
			foreach(var cell in terrain.GetReachableCellsU(game.GetSelectedUnit()))
			{
				Vector2 position = terrain.MapToWorldCentered(cell);
				DrawCircle(position, 5, new Color(255, 255, 255));
			}
		}

		// DRAW PATH
		for (int i = 0; i < game.GetSelectedUnitPath().Count; i++)
		{
			DrawCircle(terrain.MapToWorldCentered(game.GetSelectedUnitPath()[i]), 5, new Color(255, 0, 0));
		}
   }
}
