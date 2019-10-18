using Godot;
using Godot.Collections;
using System;

public class TODPeriod : Resource
{
    [Export] string name = "";
    [Export] int tintRed = 0;
    [Export] int tintGreen = 0;
    [Export] int tintBlue = 0;
    [Export] Array<string> advantage = new Array<string>();
    [Export] Array<string> disadvantage = new Array<string>();
    [Export] int bonus = 0;
    [Export] int malus = 0;
    [Export] AudioStream sound = null;
}
