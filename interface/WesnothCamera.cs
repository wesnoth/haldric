using Godot;

public class WesnothCamera : Camera2D
{
	private const int speed = 1000;
	private const int border = 4;

	private bool up;
	private bool down;
	private bool left;
	private bool right;

	public override void _Input(InputEvent @event)
	{
		Vector2 newPosition = Position;

		if (Input.IsActionJustPressed("scroll_up"))
		{
			newPosition.y -= 100;
		}
		if (Input.IsActionJustPressed("scroll_down"))
		{
			newPosition.y += 100;
		}

		SetPosition(newPosition);
	}

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

	public void Scroll(int button)
	{
		Vector2 newPosition = Position;

		if (button == 8)
		{
			newPosition.y -= 100;
		}
		else if (button == 16)
		{
			newPosition.y += 100;
		}

		SetPosition(newPosition);
	}
}
