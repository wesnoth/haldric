using Godot;
using System;

public class Unit : Sprite
{
    private const int health_max = 30;
    private const int moves_max = 5;
    private int health;
    private int moves;

    public override void _Ready()
    {
        health = health_max;
	    moves = moves_max;
    }

    public void restore()
    {
        health = health_max;
        moves = moves_max;
    }
}
