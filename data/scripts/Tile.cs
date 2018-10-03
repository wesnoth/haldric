using Godot;
using System;

public class Tile : Node2D
{
	public Vector2 cell;
	public int type;
	public int weight;
	public bool isBlocked;

	public Tile(Vector2 cell, int type, int weight = 0, bool isBlocked = false)
	{
		this.cell = cell;
		this.type = type;
		this.weight = weight;
		this.isBlocked = isBlocked;
	}
}
