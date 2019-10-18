using Godot;
using Godot.Collections;
using System;

public class TODSchedule : Resource
{
    [Export] Array<string> schedule = new Array<string>();
}
