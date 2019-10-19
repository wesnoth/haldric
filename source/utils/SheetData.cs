using Godot;
using System;
using Godot.Collections;

public class SheetData : Resource
{
    [Export] public Dictionary<Godot.Object, Dictionary<string, Godot.Object>> data = new Dictionary<Godot.Object, Dictionary<string, Godot.Object>>();
}
