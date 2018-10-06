using Godot;
using System;
using System.Xml;

public class Unit : Sprite
{
	Lifebar lifebar;
	private XmlDocument attributes;

	private int side;

	private int baseMaxHealth;
	private int baseMaxMoves;

	private int currentHealth;
	private int currentMoves;
	private int damage;

	private bool canAttack = true;

	public override void _Ready()
	{
		damage = int.Parse(attributes.SelectSingleNode("/unit_type/damage").InnerText);
		currentHealth = int.Parse(attributes.SelectSingleNode("/unit_type/hitpoints").InnerText);
		currentMoves = int.Parse(attributes.SelectSingleNode("/unit_type/movement").InnerText);

		baseMaxHealth = currentHealth;
		baseMaxMoves = currentMoves;

		lifebar = (Lifebar)GetNode("Lifebar");
		lifebar.SetValueMax(baseMaxHealth);
		lifebar.SetValue(baseMaxHealth);
	}

	public void SetAttributes(XmlDocument attributes)
	{
		this.attributes = attributes;
	}

	public int GetSide()
	{
		return side;
	}

	public int GetBaseMaxHealth()
	{
		return baseMaxHealth;
	}

	public int GetBaseMaxMoves()
	{
		return baseMaxMoves;
	}

	public int GetCurrentHealth()
	{
		return currentHealth;
	}

	public int GetCurrentMoves()
	{
		return currentMoves;
	}

	public int GetDamage()
	{
		return damage;
	}

	public void SetSide(int side)
	{
		this.side = side;
	}

	public void SetCurrentHealth(int health)
	{
		this.currentHealth = health;
		lifebar.SetValue(health);
	}

	public void SetCurrentMoves(int moves)
	{
		this.currentMoves = moves;
	}

	public void Fight(Unit unit)
	{
		unit.Harm(damage);
		canAttack = false;
		currentMoves = 0;

		if (unit.GetCurrentHealth() > 0)
		{
			Harm(unit.GetDamage());
		}
	}

	public void Harm(int damage)
	{
		SetCurrentHealth(currentHealth - damage);
	}

	public void Restore()
	{
		RestoreCurrentHealth();
		RestoreCurrentMoves();
	}

	public void RestoreCurrentHealth()
	{
		currentHealth = baseMaxHealth;
	}

	public void RestoreCurrentMoves()
	{
		currentMoves = baseMaxMoves;
	}

	public void RestoreAttack()
	{
		canAttack = true;
	}

	public bool CanAttack()
	{
		return canAttack == true;
	}


}
