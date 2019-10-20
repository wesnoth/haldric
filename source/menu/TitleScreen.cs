using Godot;
using Godot.Collections;
using System;

public class TitleScreen : Control
{
    private VBoxContainer buttons;
    public override void _Ready()
    {
        buttons = GetNode("CenterContainer/Buttons") as VBoxContainer;

        foreach (Button button in buttons.GetChildren())
        {
            button.Connect("pressed", this, "_OnButtonPressed", new Godot.Collections.Array() { button.Name });
        }
        
    }

    private void _OnButtonPressed(string buttonName)
    {
        switch (buttonName)
        {
            case "Match": 
            {
                GetTree().ChangeScene("res://source/match/Match.tscn");
            } break;
            case "Editor": 
            {
                GetTree().ChangeScene("res://source/editor/Editor.tscn");
            } break;
            case "Quit":
            {
                GetTree().Quit();
            } break;
        }
    }
}
