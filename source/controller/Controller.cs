using Godot;
using System;

public class Controller : Node
{
    enum ControlMode { Player, AI, None }

    private ControlMode mode = ControlMode.Player;
    
    public Scenario Scenario;

    public override void _UnhandledInput(InputEvent @event)
    {
        if (!(IsPlayer()) || Scenario == null) { return; }

        if (@event.IsActionPressed("mouse_left"))
        {
            GD.Print("Click!");
        }
    }

    public bool IsPlayer()
    {
        return mode == ControlMode.Player;
    }
}
