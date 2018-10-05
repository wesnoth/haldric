using Godot;
using System;

public class Unit : Sprite
{
	Lifebar lifebar;

	private int side = 1;

	private const int healthMax = 30;
	private const int movesMax = 5;

	private int health;
	private int moves;
	private int damage = 8;

	public override void _Ready()
	{
		health = healthMax;
		moves = movesMax;
		
		lifebar = (Lifebar)GetNode("Lifebar");
		lifebar.SetValueMax(healthMax);
		lifebar.SetValue(healthMax);
	}

	public int GetSide()
	{
		return side;
	}

	public int GetHealthMax()
	{
		return healthMax;
	}

	public int GetMovesMax()
	{
		return movesMax;
	}

	public int GetHealth()
	{
		return health;
	}

	public int GetMoves()
	{
		return moves;
	}

	public int GetDamage()
	{
		return damage;
	}

	public void SetSide(int side)
	{
		this.side = side;
	}
	
	public void SetHealth(int health)
	{
		this.health = health;
		lifebar.SetValue(health);
	}

	public void fight(Unit unit)
	{

		unit.Harm(damage);

		if (unit.GetHealth() > 0)
		{
			Harm(unit.GetDamage());
		}
	}

	public void Harm(int damage)
	{
		SetHealth(health - damage);
	}

	public void Restore()
	{
		health = healthMax;
		moves = movesMax;
	}
}
