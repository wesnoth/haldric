using Godot;
using System;

public class TileButton : TextureButton
{
    private static PackedScene packedScene = GD.Load<PackedScene>("res://source/editor/hud/TileButton.tscn");
    public static TileButton Instance() { return packedScene.Instance() as TileButton; }
}
