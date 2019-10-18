using Godot;
using System;

public class Attack : Node
{
    [Export] private string id = "";
    
    [Export(PropertyHint.Enum, "ranged, melee")] 
    private string reach = "";
    
    [Export(PropertyHint.Enum, "blade, impact, pierce, fire, cold, arcane")] 
    private string type = "";
    
    [Export] private int damage = 4;
    
    [Export] private int strikes = 2;
    
    [Export] private Texture icon = null;   
}