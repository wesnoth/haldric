using Godot;
using System;
using Wesnoth.SDK;

[Tool]
public class UnitType : Node2D
{
    [Export] private string id = "";
    [Export] private string name = "";

    [Export] private string race = "";
    [Export] private string alignment = "";


    [Export(PropertyHint.MultilineText)] private string description = "";

    [Export] private int cost = 0;
    [Export] private int level = 0;
    
    [Export] private int health = 0;
    [Export] private int moves = 0;
    [Export] private int experience = 0;

    [Export] private string[] advancesTo = {""};


    AnimationPlayer animationPlayer = new AnimationPlayer();
    Sprite sprite = new Sprite();

    Defense defense = new Defense();
    Movement movement = new Movement();
    Resistance resistance = new Resistance();

    Node traits = new Node();
    Node abilities = new Node();
    Node attacks = new Node();

    public int Health { get { return health; }}
    public int Moves { get { return moves; }}
    public int Experience { get { return experience; }}

    public override void _EnterTree()
    {
        if (GetNode("AnimationPlayer") as AnimationPlayer == null)
        {
            animationPlayer.Name = "AnimationPlayer";
            GD.Print("Node added: " + animationPlayer.Name);
            AddChild(animationPlayer);
            animationPlayer.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Sprite") as Sprite == null)
        {
            sprite.Name = "Sprite";
            GD.Print("Node added: " + sprite.Name);
            AddChild(sprite);
            sprite.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Defense") as Node == null)
        {
            defense.Name = "Defense";
            GD.Print("Node added: " + defense.Name);
            AddChild(defense);
            defense.Owner = GetTree().EditedSceneRoot;
            defense.SetScript(GD.Load<Script>(Scripts.Defense));
        }
        if (GetNode("Movement") as Node == null)
        {
            movement.Name = "Movement";
            GD.Print("Node added: " + movement.Name);
            AddChild(movement);
            movement.Owner = GetTree().EditedSceneRoot;
            movement.SetScript(GD.Load<Script>(Scripts.Movement));
        }
        if (GetNode("Resistance") as Node == null)
        {
            resistance.Name = "Resistance";
            GD.Print("Node added: " + resistance.Name);
            AddChild(resistance);
            resistance.Owner = GetTree().EditedSceneRoot;
            resistance.SetScript(GD.Load<Script>(Scripts.Resistance));
        }
        if (GetNode("Traits") as Node == null)
        {
            traits.Name = "Traits";
            GD.Print("Node added: " + traits.Name);
            AddChild(traits);
            traits.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Abilities") as Node == null)
        {
            abilities.Name = "Abilities";
            GD.Print("Node added: " + abilities.Name);
            AddChild(abilities);
            abilities.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Attacks") as Node == null)
        {
            attacks.Name = "Attacks";
            GD.Print("Node added: " + attacks.Name);
            AddChild(attacks);
            attacks.Owner = GetTree().EditedSceneRoot;
        }
    }

    public override string _GetConfigurationWarning()
    {
        string warning = "";
        if (Name == "UnitType")
        {
            warning += "Rename Root to Unit Type Name!\n";
        }
        if (GetNode("AnimationPlayer") as AnimationPlayer == null)
        {
            warning += "AnimationPlayer Node missing!\n";
        }
        if (GetNode("Sprite") as Sprite == null)
        {
            warning += "Sprite Node missing!\n";
        }
        if (GetNode("Defense") as Node == null)
        {
            warning += "Defense Node missing!\n";
        }
        if (GetNode("Movement") as Node == null)
        {
            warning += "Movement Node missing!\n";
        }
        if (GetNode("Resistance") as Node == null)
        {
            warning += "Resistance Node missing!\n";
        }
        if (GetNode("Traits") as Node == null)
        {
            warning += "Traits Node missing!\n";
        }
        if (GetNode("Abilities") as Node == null)
        {
            warning += "Abilities Node missing!\n";
        }
        if (GetNode("Attacks") as Node == null)
        {
            warning += "Attacks Node missing!\n";
        }

        return warning;
    }
}
