using Godot;
using System;

public class Lifebar : Node2D
{
	TextureProgress progressBar;
	public override void _Ready()
	{
		progressBar = (TextureProgress)GetNode("TextureProgress");
	}

	public void SetValueMax(int valueMax)
	{
		progressBar.MaxValue = valueMax;
	}

	public void SetValue(int value)
	{
		progressBar.Value = value;
	}
}
