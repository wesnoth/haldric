using Godot;
using System;

public class EditorHUD : CanvasLayer
{
    TileButtonPanel tileButtonPanel;

    [Export] Vector2 buttonSize = new Vector2(50, 50);

    private int brushSize = 1;
    public int BrushSize { get { return brushSize; } }

    public override void _Ready()
    {
        tileButtonPanel = GetNode("SidePanel/TileButtonPanel") as TileButtonPanel;
        tileButtonPanel.Connect("Pressed", this, "_OnButtonPressed");
        tileButtonPanel.ButtonSize = buttonSize;
        AddButtons();
    }

    public void AddButtons()
    {
        foreach (var type in Registry.terrain.Values)
        {
            AtlasTexture tex;
            
            if (type.symbolImage is AtlasTexture)
            {
                tex = type.symbolImage.Duplicate() as AtlasTexture;
            }
            else
            {
                tex = new AtlasTexture();
                tex.Atlas = type.symbolImage;
                tex.Region = new Rect2(0, 0, 72, 72);
            }

            tileButtonPanel.AddButton(type.code, tex);
        }
    }

    private void _OnButtonPressed(string buttonName)
    {
        GetTree().CallGroup("Editor", "SetTile1", buttonName);
        GD.Print("Editor set to ", buttonName);
    }

    private void _OnBrushSizeChanged(string text)
    {
        brushSize = text.ToInt();
    }
}
