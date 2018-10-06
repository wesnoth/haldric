using Godot;
using System;

public class Interface : Node2D
{

	private Sprite cursor;
	private Game game;
	private Terrain terrain;
	
	private Label sideLabel;

	private Label unitHealthLabel;
	private Label unitMovesLabel;
	private Label unitDamageLabel;
	
	private bool showGrid = false;

	public override void _Ready()
	{
		cursor = (Sprite)GetNode("Cursor");
		game = (Game)GetNode("..");
		terrain = (Terrain)GetNode("../Terrain");
		
		GetNode("GUI/EndTurn").Connect("pressed", this, "OnEndTurnPressed");
		
		sideLabel = (Label)GetNode("GUI/SideLabel");
		
		unitHealthLabel = (Label)GetNode("GUI/UnitInfo/HealthLabel"); 
		unitMovesLabel = (Label)GetNode("GUI/UnitInfo/MovesLabel"); 
		unitDamageLabel = (Label)GetNode("GUI/UnitInfo/DamageLabel"); 
	}

   public override void _Process(float delta)
   {
		Update();
		cursor.SetPosition(terrain.WorldToWorldCentered(GetGlobalMousePosition()));

		sideLabel.SetText("Side: " + game.GetActiveSide());

		if (game.GetActiveUnit() != null)
		{
			unitHealthLabel.SetText("Health: " + game.GetActiveUnit().GetCurrentHealth() + "/" + game.GetActiveUnit().GetBaseMaxHealth());
			unitMovesLabel.SetText("Moves: " + game.GetActiveUnit().GetCurrentMoves() + "/" + game.GetActiveUnit().GetBaseMaxMoves());
			unitDamageLabel.SetText("Damage: " + game.GetActiveUnit().GetDamage());
		}
		else
		{
			unitHealthLabel.SetText("Health: -");
			unitMovesLabel.SetText("Moves: -");
			unitDamageLabel.SetText("Damage: -");
		}
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
