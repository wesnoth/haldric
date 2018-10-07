using System.Collections.Generic;
using Godot;

public class Game : Node2D
{
	MoveHandler moveHandler;
	Terrain terrain;
	Node units;

	private int sides = 2;

	private int activeSide = 1;

	Unit activeUnit = null;
	IList<Vector2> activeUnitPath = new List<Vector2>();

	public override void _Ready()
	{
		UnitRegistry.LoadDir("units/config/");

		moveHandler = (MoveHandler)GetNode("MoveHandler");
		terrain = (Terrain)GetNode("Terrain");
		units = (Node)GetNode("UnitContainer");

		PackedScene unitScene = (PackedScene)ResourceLoader.Load("res://units/Unit.tscn");

		CreateUnit("Elvish Fighter", 1, 10, 1);
		CreateUnit("Elvish Archer", 1, 11, 1);
		CreateUnit("Elvish Scout", 1, 9, 1);
		CreateUnit("Elvish Shaman", 1, 8, 1);

		CreateUnit("Orcish Grunt", 2, 10, 13);
		CreateUnit("Orcish Archer", 2, 9, 13);
		CreateUnit("Orcish Assassin", 2, 11, 13);
		CreateUnit("Troll Whelp", 2, 12, 13);
	}

	public override void _Input(InputEvent @event)
	{
		if (activeUnit != null)
		{
			Vector2 mouseCell = terrain.WorldToMap(GetGlobalMousePosition());
			Vector2 unitCell = terrain.WorldToMap(activeUnit.GetPosition());
			activeUnitPath = terrain.FindPathByCell(unitCell, mouseCell);
		}

		if (Input.IsActionJustPressed("mouse_left"))
		{
			Vector2 mouseCell = terrain.WorldToMap(GetGlobalMousePosition());

			if (IsUnitAtCell(mouseCell) && activeUnit == null)
			{
				activeUnit = GetUnitAtCell(mouseCell);
			}
			else if (IsUnitAtCell(mouseCell) && activeUnit != null)
			{
				Unit unit = (Unit)GetUnitAtCell(mouseCell);

				if (unit.GetSide() != activeUnit.GetSide()
					&& terrain.AreNeighbors(mouseCell, terrain.WorldToMap(activeUnit.GetPosition()))
					&& activeUnit.CanAttack()
					&& activeSide == activeUnit.GetSide())
				{
					activeUnit.Fight(unit);

					if (activeUnit.GetCurrentHealth() < 1)
					{
						activeUnit.QueueFree();
						DeselectActiveUnit();
					}
					else
					{
						GD.Print("Attacker: ", activeUnit.GetCurrentHealth(), "/", activeUnit.GetBaseMaxHealth());
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
			else if (!IsUnitAtCell(mouseCell) && activeUnit != null && !IsCellBlocked(mouseCell) && activeSide == activeUnit.GetSide())
			{
				moveHandler.MoveUnit(activeUnit, activeUnitPath);
			}
		}

		if (Input.IsActionJustPressed("mouse_right"))
		{
			DeselectActiveUnit();
		}
	}

	public void CreateUnit(string type, int side, int x, int y)
	{
		Unit unit = UnitRegistry.Create(type, side, x, y);
		unit.SetPosition(terrain.MapToWorldCentered(new Vector2(x, y)));
		units.AddChild(unit);

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

	public Unit GetActiveUnit()
	{
		return activeUnit;
	}

	public int GetActiveSide()
	{
		return activeSide;
	}

	public void DeselectActiveUnit()
	{
		activeUnit = null;
		activeUnitPath.Clear();
	}

	public IList<Vector2> GetActiveUnitPath()
	{
		return activeUnitPath;
	}

	public void EndTurn()
	{
		foreach (Unit u in units.GetChildren())
		{
			u.RestoreCurrentMoves();
			u.RestoreAttack();
		}

		activeSide = (activeSide % sides) + 1;
	}
}