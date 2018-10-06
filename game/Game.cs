using System.Collections.Generic;
using Godot;

public class Game : Node2D
{
	MoveHandler moveHandler;
	Terrain terrain;
	Node units;

	Unit selectedUnit = null;
	IList<Vector2> selectedUnitPath = new List<Vector2>();

	public override void _Ready()
	{
		UnitRegistry.LoadDir("units/config/");

		moveHandler = (MoveHandler)GetNode("MoveHandler");
		terrain = (Terrain)GetNode("Terrain");
		units = (Node)GetNode("UnitContainer");

		PackedScene unitScene = (PackedScene)ResourceLoader.Load("res://units/Unit.tscn");
		units.AddChild(UnitRegistry.Create("Sprite", terrain, 1, 5, 3));
		units.AddChild(UnitRegistry.Create("Elvish Fighter", terrain, 2, 5, 12));
		units.AddChild(UnitRegistry.Create("Master Of Curses", terrain, 3, 15, 3));
		units.AddChild(UnitRegistry.Create("Vengeance", terrain, 4, 15, 12));
		units.AddChild(UnitRegistry.Create("Elvish Fighter", terrain, 1, 5, 5));
	}

	public override void _Input(InputEvent @event)
	{
		if (selectedUnit != null)
		{
			Vector2 mouseCell = terrain.WorldToMap(GetGlobalMousePosition());
			Vector2 unitCell = terrain.WorldToMap(selectedUnit.GetPosition());
			selectedUnitPath = terrain.FindPathByCell(unitCell, mouseCell);
		}

		if (Input.IsActionJustPressed("mouse_left"))
		{
			Vector2 mouseCell = terrain.WorldToMap(GetGlobalMousePosition());

			if (IsUnitAtCell(mouseCell) && selectedUnit == null)
			{
				selectedUnit = GetUnitAtCell(mouseCell);
			}
			else if (IsUnitAtCell(mouseCell) && selectedUnit != null)
			{
				Unit unit = (Unit)GetUnitAtCell(mouseCell);
				if (unit.GetSide() != selectedUnit.GetSide() && terrain.AreNeighbors(mouseCell, terrain.WorldToMap(selectedUnit.GetPosition())))
				{
					selectedUnit.Fight(unit);

					if (selectedUnit.GetCurrentHealth() < 1)
					{
						selectedUnit.QueueFree();
						DeselectSelectedUnit();
					}
					else
					{
						GD.Print("Attacker: ", selectedUnit.GetCurrentHealth(), "/", selectedUnit.GetBaseMaxHealth());
					}

					if (unit.GetCurrentHealth() < 1)
					{
						unit.QueueFree();
					}
					else
					{
						GD.Print("Defender: ", unit.GetCurrentHealth(), "/", unit.GetBaseMaxHealth());
					}
				}
			}
			else if (!IsUnitAtCell(mouseCell) && selectedUnit != null && !IsCellBlocked(mouseCell))
			{
				moveHandler.MoveUnit(selectedUnit, selectedUnitPath);
			}
		}

		if (Input.IsActionJustPressed("mouse_right"))
		{
			DeselectSelectedUnit();
		}
	}

	public bool IsUnitAtCell(Vector2 cell)
	{
		foreach (Unit u in units.GetChildren())
		{
			if (u.GetPosition() == terrain.MapToWorldCentered(cell))
			{
				return true;
			}
		}
		return false;
	}

	public bool IsCellBlocked(Vector2 cell)
	{
		return terrain.GetTiles()[terrain.FlattenV(cell)].isBlocked;
	}

	public Unit GetUnitAtCell(Vector2 cell)
	{
		foreach (Unit u in units.GetChildren())
		{
			if (u.GetPosition() == terrain.MapToWorldCentered(cell))
			{
				return u;
			}
		}
		return null;
	}

	public Unit GetSelectedUnit()
	{
		return selectedUnit;
	}

	public void DeselectSelectedUnit()
	{
		selectedUnit = null;
		selectedUnitPath.Clear();
	}

	public IList<Vector2> GetSelectedUnitPath()
	{
		return selectedUnitPath;
	}

	public void EndTurn()
	{
		foreach(Unit u in units.GetChildren())
		{
			u.RestoreCurrentMoves();
		}
	}
}