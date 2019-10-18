using Godot;
using Godot.Collections;
using System;

public class TerrainType : Resource
{
    [Export] public int layer = 0;

    [Export] public string code = "";
    [Export] public string name = "";
    [Export] public string type = "";

    [Export] public bool recruitOnto = false;
    [Export] public bool recruitFrom = false;

    [Export] public bool heals = false;
    [Export] public bool givesIncome = false;

    [Export] public bool submerge = false;

    [Export] public Texture symbolImage = null;
    [Export] public Texture editorImage = null;
    [Export] public Texture iconImage = null;
}
