using Godot;
using System;

public class Unit : Sprite
{
	private const int healthMax = 30;
	private const int movesMax = 5;
	private int health;
	private int moves;

	public override void _Ready()
	{
		health = healthMax;
		moves = movesMax;
	}

	public int GetMovesMax()
	{
		return movesMax;
	}
	public void restore()
	{
		health = healthMax;
		moves = movesMax;
	}
}
