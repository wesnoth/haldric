using Godot;
using System;

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


    AnimationPlayer animationPlayer;
    Sprite sprite;

    Defense defense;
    Movement movement;
    Resistance resistance;

    Node traits;
    Node abilities;
    Node attacks;

    public int Health { get { return health; }}
    public int Moves { get { return moves; }}
    public int Experience { get { return experience; }}

    public override void _Ready()
    {
        animationPlayer = GetNode("AnimationPlayer") as AnimationPlayer;
        sprite = GetNode("Sprite") as Sprite;
        defense = GetNode("Defense") as Defense;
        movement = GetNode("Movement") as Movement;
        resistance = GetNode("Resistance") as Resistance;
        traits = GetNode("Traits") as Node;
        abilities = GetNode("Abilities") as Node;
        attacks = GetNode("Attacks") as Node;
    }

    public override void _EnterTree()
    {
        if (GetNode("AnimationPlayer") as AnimationPlayer == null)
        {
            animationPlayer = new AnimationPlayer();
            animationPlayer.Name = "AnimationPlayer";
            GD.Print("Node added: " + animationPlayer.Name);
            AddChild(animationPlayer);
            animationPlayer.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Sprite") as Sprite == null)
        {
            sprite = new Sprite();
            sprite.Name = "Sprite";
            GD.Print("Node added: " + sprite.Name);
            AddChild(sprite);
            sprite.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Defense") as Node == null)
        {
            defense = Defense.New();
            defense.Name = "Defense";
            GD.Print("Node added: " + defense.Name);
            AddChild(defense);
            defense.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Movement") as Node == null)
        {
            movement = Movement.New();
            movement.Name = "Movement";
            GD.Print("Node added: " + movement.Name);
            AddChild(movement);
            movement.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Resistance") as Node == null)
        {
            resistance = Resistance.New();
            resistance.Name = "Resistance";
            GD.Print("Node added: " + resistance.Name);
            AddChild(resistance);
            resistance.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Traits") as Node == null)
        {
            traits = new Node();
            traits.Name = "Traits";
            GD.Print("Node added: " + traits.Name);
            AddChild(traits);
            traits.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Abilities") as Node == null)
        {
            abilities = new Node();
            abilities.Name = "Abilities";
            GD.Print("Node added: " + abilities.Name);
            AddChild(abilities);
            abilities.Owner = GetTree().EditedSceneRoot;
        }
        if (GetNode("Attacks") as Node == null)
        {
            attacks = new Node();
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
