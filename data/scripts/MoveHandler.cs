using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

public class MoveHandler : Node
{
	// enum DIRECTION {SE, NE, N, NW, SW, S}

	Vector2 speed = new Vector2(200, 200);

	Terrain terrain;

	IList<Vector2> path = new List<Vector2>();
	Unit unit = new Unit();

	Vector2 lastPoint;

	public override void _Ready()
	{
		SetProcess(true);
		terrain = (Terrain) GetNode("../Terrain");
	}

	public override void _Process(float delta)
	{
		if (path.Count > 0)
		{
			Vector2 nextCell = terrain.MapToWorldCentered(path[0]);
			Vector2 direction = GetMoveDirection();
			Vector2 velocity = direction * speed * delta;
			
            unit.SetPosition(unit.GetPosition() + velocity);

			if(unit.GetPosition() * direction > terrain.MapToWorldCentered(path[0]) * direction)
			{
				lastPoint = path[0];
				path.RemoveAt(0);
				
				if (path.Count == 0)
				{
					unit = null;
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
