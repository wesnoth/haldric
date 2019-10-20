using Godot;
using System;

public class Controller : Node
{
    enum ControlMode { Player, AI, None }

    ControlMode controller = ControlMode.Player;
    
    public override void _UnhandledInput(InputEvent @event)
    {

    }
}
