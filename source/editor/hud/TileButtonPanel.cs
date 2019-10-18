using Godot;
using System;

public class TileButtonPanel : Panel
{
    [Signal] delegate void Pressed(string buttonName);

    private Vector2 buttonSize = new Vector2(50, 50);

    // Child Nodes    
    GridContainer buttons;

    public override void _Ready()
    {
        buttons = GetNode("MarginContainer/GridContainer") as GridContainer;
    }

    public Vector2 ButtonSize {
        set { buttonSize = value; }
        get { return buttonSize; }
    }

    public void AddButton(string terrainName, AtlasTexture terrainTexture)
    {
        terrainTexture.Region = NormalizeRegion(terrainTexture.Region);

        var button = TileButton.Instance();
        button.Name = terrainName;
        button.TextureNormal = terrainTexture;
        button.Connect("pressed", this, "_OnButtonPressed", new Godot.Collections.Array { terrainName });
        buttons.AddChild(button);
    }

    private Rect2 NormalizeRegion(Rect2 region)
    {
        Vector2 rectPosition = (region.Position + (region.Size / 2f)) - new Vector2(buttonSize.x / 2f, buttonSize.y / 2f);
        return new Rect2(rectPosition, buttonSize);
    }

    private void _OnButtonPressed(string buttonName)
    {
        EmitSignal("Pressed", buttonName);
    }
}
