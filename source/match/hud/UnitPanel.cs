using Godot;
using System;

public class UnitPanel : Panel
{
    
    private Label name;
    private Label hp;
    private Label mp;
    private Label xp;
    private TextureRect image;

    public override void _Ready()
    {
        name = GetNode("CenterContainer/VBoxContainer/Name") as Label;
        hp = GetNode("CenterContainer/VBoxContainer/HP/Value") as Label;
        mp = GetNode("CenterContainer/VBoxContainer/MP/Value") as Label;
        xp = GetNode("CenterContainer/VBoxContainer/XP/Value") as Label;
        image = GetNode("CenterContainer/VBoxContainer/TextureRect") as TextureRect;
    }

    public void UpdateUnit(Unit unit)
    {
        name.Text = unit.Name;

        hp.Text = String.Format("{0} / {1}", unit.Health, unit.Type.Health);
        mp.Text = String.Format("{0} / {1}", unit.Moves, unit.Type.Moves);
        xp.Text = String.Format("{0} / {1}", unit.Experience, unit.Type.Experience);

        image.Texture = unit.Type.Texture;
    }
}
