using Godot;
using System;

public class Unit : Sprite
{

	Lifebar lifebar;
	private const int healthMax = 30;
	private const int movesMax = 5;
	private int health;
	private int moves;

	public override void _Ready()
	{
		health = healthMax;
		moves = movesMax;
		
		lifebar = (Lifebar)GetNode("Lifebar");
		lifebar.SetValueMax(healthMax);
		lifebar.SetValue(healthMax);
	}

	public int GetMovesMax()
	{
		return movesMax;
	}

	public void SetHealth(int health)
	{
		this.health = health;
		lifebar.SetValue(health);
	}

	public void Restore()
	{
		health = healthMax;
		moves = movesMax;
	}
}
