using Godot;
using System;

public class TitleScreen : Control
{
    public override void _Ready()
    {
        GetTree().ChangeScene("res://source/editor/Editor.tscn");
    }
}
