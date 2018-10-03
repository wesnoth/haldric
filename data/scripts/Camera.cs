using Godot;
using System;

public class Camera : Camera2D
{
    private const int speed = 1000;
    private const int border = 4;

    private bool up;
    private bool down;
    private bool left;
    private bool right;

   public override void _Process(float delta)
   {
        up = Input.IsActionPressed("ui_up");
        down = Input.IsActionPressed("ui_down");
        left = Input.IsActionPressed("ui_left");
        right = Input.IsActionPressed("ui_right");

        Vector2 newPosition = Position;

        if (up)
        {
           newPosition.y -= speed * delta / 2;
        }

        if (down)
        {
            newPosition.y += speed * delta / 2;
        }

        if (left)
        {
            newPosition.x -= speed * delta / 2;
        }

        if (right)
        {
            newPosition.x += speed * delta / 2;
        }

        SetPosition(newPosition);
   }
}
