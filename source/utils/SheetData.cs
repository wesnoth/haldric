using Godot;
using System;
using Godot.Collections;

public class RDict : Resource
{
    [Export] public Dictionary<int, Dictionary<string, Godot.Object>> data = null;
}
