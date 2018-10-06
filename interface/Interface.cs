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

		GetNode("GUI/EndTurn").Connect("pressed", this, "OnEndTurnPressed");
	}

   public override void _Process(float delta)
   {
		Update();
		cursor.SetPosition(terrain.WorldToWorldCentered(GetGlobalMousePosition()));
   }

   public override void _Draw()
	{
		if (game.GetActiveUnit() != null)
		{
			// DRAW REACHABLE
			foreach(var cell in terrain.GetReachableCellsU(game.GetActiveUnit()))
			{
				Vector2 position = terrain.MapToWorldCentered(cell);
				DrawCircle(position, 5, new Color(255, 255, 255));
			}
		}

		// DRAW PATH
		for (int i = 0; i < game.GetActiveUnitPath().Count; i++)
		{
			DrawCircle(terrain.MapToWorldCentered(game.GetActiveUnitPath()[i]), 5, new Color(255, 0, 0));
		}
   }

   private void OnEndTurnPressed()
   {
	   game.EndTurn();
   }
}
