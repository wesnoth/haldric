using Godot;
using System;

public class Controller : Node2D
{
    [Signal] delegate void ClickedLeft();
    
    [Signal] delegate void ClickedRight();

    enum ControlMode { Player, AI, None }

    public Scenario Scenario;

    private ControlMode mode = ControlMode.Player;
    
    public override void _UnhandledInput(InputEvent @event)
    {
        if (!(IsPlayer()) || Scenario == null) { return; }

        if (@event.IsActionPressed("mouse_left"))
        {
            var mousePosition = GetGlobalMousePosition();
            var unit = Scenario.GetUnitAt(mousePosition);

            if (unit == null) { return; }
            
            GD.Print(unit.Name);
        }

        if (@event.IsActionPressed("mouse_right"))
        {
            EmitSignal("ClickedRight");
        }
    }

    public bool IsPlayer()
    {
        return mode == ControlMode.Player;
    }
}
