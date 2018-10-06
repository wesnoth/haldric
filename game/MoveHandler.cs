using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

public class MoveHandler : Node
{
	// enum DIRECTION {SE, NE, N, NW, SW, S}

	private Vector2 speed = new Vector2(400, 400);

	private Game game;
	private Terrain terrain;

	private IList<Vector2> path = new List<Vector2>();
	private Unit unit = new Unit();

	private Vector2 lastPoint;

	private int initialPathSize = 0;

	public override void _Ready()
	{
		SetProcess(true);
		game = (Game)GetParent();
		terrain = (Terrain)GetNode("../Terrain");
	}

	public override void _Process(float delta)
	{
		if (path.Count > 0)
		{
			if (initialPathSize == 0)
			{
				initialPathSize = path.Count;
			}
			Vector2 nextCell = terrain.MapToWorldCentered(path[0]);
			Vector2 direction = GetMoveDirection();
			Vector2 velocity = direction * speed * delta;
			
			unit.SetPosition(unit.GetPosition() + velocity);

			if(unit.GetPosition() * direction > terrain.MapToWorldCentered(path[0]) * direction)
			{
				unit.SetPosition(terrain.WorldToWorldCentered(unit.GetPosition()));
				if (path.Count < initialPathSize)
				{
					unit.SetCurrentMoves(unit.GetCurrentMoves() - 1);
				}
				lastPoint = path[0];
				path.RemoveAt(0);

				
				if (path.Count == 0 || unit.GetCurrentMoves() == 0)
				{
					if (unit.GetCurrentMoves() == 0)
					{
						path.Clear();
						game.DeselectActiveUnit();
					}
					unit.SetPosition(terrain.WorldToWorldCentered(unit.GetPosition()));
					unit = null;
					initialPathSize = 0;
				}
				
			}
		} 
	}

	public void MoveUnit(Unit unit, IList<Vector2> path)
	{
		this.path = path;
		
		if (path.Count > 0) 
		{
			lastPoint = terrain.MapToWorldCentered(unit.GetPosition());
			this.unit = unit;
		}
	}

   private Vector2 GetMoveDirection()
   {
	   return (terrain.MapToWorldCentered(path[0]) - terrain.MapToWorldCentered(lastPoint)).Normalized();
   }
}
